/**
*  TiempoBus - Informacion sobre tiempos de paso de autobuses en Alicante
*  Copyright (C) 2014 Alberto Montiel
*
*
*  This program is free software: you can redistribute it and/or modify
*  it under the terms of the GNU General Public License as published by
*  the Free Software Foundation, either version 3 of the License, or
*  (at your option) any later version.
*
*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import QtQuick 2.2
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.Popups 1.0

import "../components"

Tab {
    id: tabPrincipal
    title: i18n.tr("TiempoBus")
    page: Page {

        id: paginaTiempos

        Component.onCompleted: {
            cargaInicial()
        }

        onVisibleChanged: {
            if (controlCambioParada) {
                console.log("Recarga por parada cambiada")
                paradaCambiada()
                controlCambioParada = false
            }

            favoritoIndex = ''
        }

        //Timer para la automatica de tiempos
        Timer {
            id: timerTiempos
            interval: 60000
            running: false
            repeat: true
            onTriggered: {

                console.debug("Recarga automatica")
                paradaSeleccionada()
            }
        }

        Column {
            id: pageLayout

            anchors {
                fill: parent
                margins: units.gu(2)
            }

            spacing: units.gu(1)

            Row {
                spacing: units.gu(1)

                UbuntuShape {
                    id: shape1
                    objectName: "ubuntushape_sizes_15_6"
                    color: Theme.palette.normal.foreground
                    //width: tituloParada.width + hora1.width + hora.width
                    width: units.gu(45)
                    height: tituloParada.height + hora1.height




                    //anchors.verticalCenter: parent.verticalCenter
                    Label {
                        id: tituloParada
                        text: i18n.tr("Bus Stop: ")
                        color: Theme.palette.normal.foregroundText
                    }

                    Label {
                        id: hora1
                        anchors.top: tituloParada.bottom
                        text: i18n.tr("Updated at: ")
                        color: Theme.palette.normal.foregroundText
                    }

                    Label {
                        id: hora
                        anchors.top: tituloParada.bottom
                        anchors.left: hora1.right
                        text: "00:00"
                        color: Theme.palette.normal.foregroundText
                    }
                }
            }

            Row {
                spacing: units.gu(1)
                id: entradaDatos

                Button {
                    id: botonTiempos
                    text: i18n.tr("Load")
                    onClicked: paradaSeleccionada()
                }

                TextField {
                    id: entradaParada
                    placeholderText: i18n.tr("Bus stop")

                    maximumLength: 4
                    width: units.gu(12)

                    validator: IntValidator {
                        bottom: 1
                        top: 5000
                    }
                    focus: true
                }



            }

            Row {

                spacing: units.gu(1)

                Label {
                    id: listadoVacio
                    //anchors.centerIn: parent
                    text: ">>" + i18n.tr("No information") + "\n" + i18n.tr(
                              "Check the Bus Timetable") + "\n\n" + i18n.tr(
                              "This application is UNofficial and its development is independent.\nLines and times data offered and maintained by: subus.es\nDevelopment: alberapps.blogspot.com - twitter.com/alberapps")
                    fontSize: "small"
                    //width: parent.width
                    //anchors.margins: units.gu(100)
                    wrapMode: "Wrap"
                    visible: false
                    //anchors.top: entradaDatos.bottom
                }

                Label {
                }
            }

            //Listado de tiempos
            Row {

                id: row3


                //anchors.topMargin: units.gu(5)
                spacing: units.gu(1)
            }

            //Listado
            UbuntuListView {
                id: listadoTiempos
                //anchors.top: entradaParada.bottom
                width: parent.width
                //anchors.topMargin: units.gu(20)
                height: parent.height - units.gu(10)
                //anchors.centerIn: parent
                model: tiempos
                delegate: ListItem.Subtitled {
                    text: linea + " - " + ruta
                    subText: formatearTiempos(minutos1, minutos2)

                    onClicked: {
                        console.debug('tiempo seleccionado')
                    }
                }

                footer: ListItem.Subtitled {

                    text: i18n.tr("Notice")
                    subText: i18n.tr(
                                 "This application is UNofficial and its development is independent.\nLines and times data offered and maintained by: subus.es\nDevelopment: alberapps.blogspot.com - twitter.com/alberapps")
                }
            }


        }

        tools: ToolbarItems {

            ToolbarButton {
                action: Action {
                    text: i18n.tr("Save")
                    iconName: "bookmark-new"
                    onTriggered: {
                        modificarFavorito = ''
                        paradaModificar = paradaActual
                        pageStack.push(formGuardar)
                    }
                }
            }

            ToolbarButton {
                action: Action {
                    text: i18n.tr("Settings")
                    iconName: "settings"
                    onTriggered: pageStack.push(formPreferencias)
                }
            }

            locked: false
            opened: true
        }
    }

    //Modelo para listado de tiempos
    ListModel {
        id: tiempos
        ListElement {
            parada: ""
            ruta: ""
            linea: ""
            minutos1: ""
            minutos2: ""
        }

        function getParada(idx) {
            return (idx >= 0 && idx < count) ? get(idx).parada : ""
        }

        function getRuta(idx) {
            return (idx >= 0 && idx < count) ? get(idx).ruta : ""
        }

        function getMinutos1(idx) {
            return (idx >= 0 && idx < count) ? get(idx).minutos1 : ""
        }

        function getDestino() {
            //return (idx >= 0 && idx < count) ? get(idx).currency: ""
            return ""
        }
    }

    //Carga inicial al entrar en la aplicacion
    function cargaInicial() {

        //Carga inicial de preferencias
        cargarPreferencias()
        paradaActual = preferencias.paradaInicial

        //Fin carga preferencias

        //Inicializar
        entradaParada.text = paradaActual

        paradaSeleccionada()

        //Carga automatica segun preferencias
        if (preferencias.cargaAutomatica === "true") {
            timerTiempos.running = true

            console.debug("Iniciada carga automatica")
        }

        console.debug("valor automatica: " + preferencias.cargaAutomatica)
    }

    /*
         * Parada cambiada desde favoritos o buscador
             */
    function paradaCambiada() {
        entradaParada.text = paradaActual
        paradaSeleccionada()
    }

    /*
         * Seleccion de parada
             */
    function paradaSeleccionada() {

        var parada = entradaParada.text


        cargarTiempos(parada)

        hora.text = Qt.formatTime(new Date(), "hh:mm")

        paradaActual = entradaParada.text


        //Guardar en preferencias
        //console.log('PREFERENCIAS A GUARDAR: ' + paradaActual);
        //preferencias.paradaInicial = paradaActual;
        guardarPreferencias()
        //console.log('PREFERENCIAS SELECCIONADA: ' + preferencias.paradaInicial)


        var datos = cargarDatosParada(parada, false);

        if(datos !== null){

            tituloParada.text = parada + '\n' +datos.direccion + '\nT: ' + datos.conexion;

        }else{

            tituloParada.text = i18n.tr("Bus Stop: ") + parada

        }



    }

    /*
        * Formatea los tiempos de salida
            */
    function formatearTiempos(minutos1, minutos2) {

        var dato = ''

        if (minutos1 !== '0') {

            //Tiempo
            dato += minutos1 + " " + i18n.tr("min")

            //Hora
            var dateTime = new Date()
            var minutos1Int = parseInt(minutos1)
            dateTime.setMinutes(new Date().getMinutes() + minutos1Int)
            dato += " (" + Qt.formatTime(dateTime, "hh:mm") + ")"
        } else {
            dato += i18n.tr("At bus stop")
        }

        if (minutos2 !== '-1') {

            dato += " " + i18n.tr("and") + " " + minutos2 + " " + i18n.tr("min")

            //Hora
            var dateTime2 = new Date()
            var minutos2Int = parseInt(minutos2)
            dateTime2.setMinutes(new Date().getMinutes() + minutos2Int)
            dato += " (" + Qt.formatTime(dateTime2, "hh:mm") + ")"
        } else {
            dato += " " + i18n.tr("and") + " " + i18n.tr("No data")
        }

        return dato
    }

    //Carga la lista de tiempos de la parada
    function cargarTiempos(parada) {

        console.debug("cargar tiempos parada: " + parada)

        indeterminateBar.visible = true

        tiempos.clear()

        var doc = new XMLHttpRequest()

        doc.open("POST",
                 "http://isaealicante.subus.es/services/dinamica.asmx", true)

        var sr = '<?xml version="1.0" encoding="utf-8"?>'
                + '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' + '<soap:Body>'
                + '<GetPasoParada xmlns="http://tempuri.org/">' + //'<linea>24</linea>'+
                //'<parada>4450</parada>'+
                '<parada>' + parada + '</parada>' + '<status>0</status>'
                + '</GetPasoParada>' + '</soap:Body>' + '</soap:Envelope>'

        console.debug(sr)

        doc.onreadystatechange = function () {

            if (doc.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                console.debug("Headers: ")
                console.debug(doc.getAllResponseHeaders())
                console.debug("last modified: ")
                console.debug(doc.getResponseHeader("Last-Modified"))
            } else if (doc.readyState === XMLHttpRequest.DONE) {

                console.debug("salida: " + doc.responseText)

                var a = doc.responseXML.documentElement
                for (var ii = 0; ii
                     < a.childNodes[0].childNodes[0].childNodes[0].childNodes.length; ++ii) {

                    //PasoParada
                    var pasoParada = a.childNodes[0].childNodes[0].childNodes[0].childNodes[ii]

                    //e1
                    var minutos1 = pasoParada.childNodes[1].childNodes[0].childNodes[0].nodeValue

                    //e1
                    var minutos2 = pasoParada.childNodes[2].childNodes[0].childNodes[0].nodeValue

                    //linea
                    var linea = pasoParada.childNodes[3].childNodes[0].nodeValue

                    //parada
                    var parada = pasoParada.childNodes[4].childNodes[0].nodeValue

                    //ruta
                    var ruta = pasoParada.childNodes[5].childNodes[0].nodeValue

                    console.debug(
                                "Node: " + parada + linea + ruta + minutos1 + minutos2)

                    tiempos.append({
                                       parada: parada,
                                       linea: linea,
                                       ruta: ruta,
                                       minutos1: minutos1,
                                       minutos2: minutos2
                                   })
                }

                console.debug("prueba: " + tiempos.getParada(1))

                console.debug("DONE: Headers: ")
                console.debug(doc.getAllResponseHeaders())
                console.debug("last modified: ")
                console.debug(doc.getResponseHeader("Last-Modified"))
            }

            indeterminateBar.visible = false

            console.debug("tiem: " + tiempos.count)

            if (tiempos.count < 1) {
                listadoVacio.visible = true
                listadoTiempos.visible = false
            } else {
                listadoVacio.visible = false
                listadoTiempos.visible = true
            }
        }

        doc.setRequestHeader('Content-Type', 'text/xml; charset=utf-8')

        doc.send(sr)
    }





    /** FUNCIONES BASE DE DATOS LINEAS
      */
    //Cargar datos de la parada
    function cargarDatosParada(parada){

        var db = LocalStorage.openDatabaseSync("TiempoBusInfoLineasDB", "1.0", "Base de datos de favoritos", 1000000);

        var datosParada;

        db.transaction(
                    function(tx) {


                        console.debug('consulta parada: ' + parada);

                        var control = true;


                            try{

                                var rs2 = tx.executeSql('SELECT ROWID,* FROM LINEAS');


                                if(rs2.rows.length > 0 ){

                                    control = true;

                                }else{
                                     control = false;

                                    tituloParada.text = 'Actualizando Base de Datos';

                                    //cargarDatosLineas(parada);

                                    PopupUtils.open(dialogoActualizacion);

                                }


                            }catch(error){

                                control = false;

                                //Iniciar recarga de la base de datos

                                //PopupUtils.open(dialogoActualizacion);
                                console.error('no hay tabla: ' + error);

                                tituloParada.text = 'Actualizando Base de Datos';

                                //cargarDatosLineas(parada);

                                PopupUtils.open(dialogoActualizacion);


                            }



                        //Si todo correcto
                        if(control){

                            // Preferencia parada inicial
                            var rs = tx.executeSql('SELECT ROWID,* FROM LINEAS WHERE PARADA = \'' + parada + '\'');

                            console.debug("resultados: " + rs.rows.length);



                            if(rs.rows.length > 0 ){

                                datosParada = {"numLinea": rs.rows.item(0).LINEA_NUM, "lineasDesc": rs.rows.item(0).LINEA_DESC, "destino": rs.rows.item(0).DESTINO, "parada": rs.rows.item(0).PARADA, "coordenadas": rs.rows.item(0).COORDENADAS, "direccion": rs.rows.item(0).DIRECCION, "conexion": rs.rows.item(0).CONEXION, "observaciones": rs.rows.item(0).OBSERVACIONES}

                            }else{

                                datosParada = {"numLinea": '', "lineasDesc": ''}

                            }



                        }




                    }
                    )



        //console.debug("datos parada: " + datosParada.direccion);


        return datosParada;

    }




















}
