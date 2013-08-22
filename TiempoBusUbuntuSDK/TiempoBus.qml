/**
 *  TiempoBus - Informacion sobre tiempos de paso de autobuses en Alicante
 *  Copyright (C) 2013 Alberto Montiel
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
import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import "components"
import Ubuntu.Components.Popups 0.1
import QtQuick.XmlListModel 2.0
import QtQuick.LocalStorage 2.0
import "Utilidades.js" as Utilidades

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the .desktop filename
    applicationName: "TiempoBus"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    //xmlhttprequest

    width: units.gu(100)
    height: units.gu(75)


    property string paradaActual: '4450';

    property string modificarFavorito: '';
    property string paradaModificar: '';

    PageStack {
            id: pageStack
            Component.onCompleted: push(paginaTiempos);


    Page {

            id: paginaTiempos
            title: i18n.tr("TiempoBus")
            Component.onCompleted: cargaInicial();



            Label {
                id: tituloParada
                anchors.topMargin: parent
                text: "Parada: "
            }

            Column {
                id:columna1
                spacing: units.gu(1)
                anchors {
                    margins: units.gu(2)
                    fill: parent
                }


                Label {
                    id: listadoVacio
                    anchors.centerIn: parent
                    text: i18n.tr("Sin resultados")
                    visible: false
                }



                ListView{
                    id:listadoTiempos
                    width: parent.width
                    height: parent.height - units.gu(10)
                    model: tiempos
                    delegate: ListItem.Subtitled{
                        text: linea + " - " + ruta
                        subText: formatearTiempos(minutos1,minutos2)

                        onClicked: {
                            console.debug('prueba');
                        }
                    }

                }



                Item{

                    anchors.top: listadoTiempos.bottom
                    anchors.bottomMargin: parent
                    anchors.horizontalCenter: parent.horizontalCenter


                    width: parent.width / 2

                    Label {
                        id: hora

                        text: "00:00"

                    }

                TextField {
                    id: entradaParada
                       placeholderText: i18n.tr("Parada")

                       anchors.left: hora.right
                       anchors.leftMargin: units.gu(2)

                       validator: IntValidator{bottom: 1; top: 5000;}
                       focus: true

                   }

                Button {
                       text: i18n.tr("Cargar")
                       onClicked: paradaSeleccionada()
                       anchors.left: entradaParada.right
                       anchors.leftMargin: units.gu(2)



                   }

                }



            }


            tools: ToolbarActions {

                Action {
                    text: i18n.tr("Favoritos")
                    iconSource: Qt.resolvedUrl("call_icon.png")
                    onTriggered: {
                        cargarFavoritos();
                        pageStack.push(paginaFavoritos);
                    }
                }
                Action {
                    text: i18n.tr("Guardar")
                    iconSource: Qt.resolvedUrl("call_icon.png")
                    onTriggered: {modificarFavorito = '';
                        paradaModificar = paradaActual;
                        pageStack.push(formGuardar);}
                }
                Action {
                    text: i18n.tr("Acerca de")
                    iconSource: Qt.resolvedUrl("call_icon.png")
                    onTriggered: pageStack.push(acercade)
                }
                Action {
                    text: i18n.tr("Buscador")
                    iconSource: Qt.resolvedUrl("call_icon.png")
                    onTriggered: pageStack.push(buscador)
                }


            }

            /*
            tools: ToolbarItems {
                ToolbarButton {
                    id: actionsButton
                    action: Action {
                        iconSource: "call_icon.png"
                        text: "Opciones"
                        onTriggered: PopupUtils.open(actionSelectionPopover, actionsButton)
                    }
                 }

                locked: false
                opened: true
            }
  */
        }


        Page {
            title: i18n.tr("Guardar parada")
            id: formGuardar
            visible: false


            Column {
                id: pageLayout

                anchors {
                    fill: parent
                    margins: units.gu(5)


                }
                spacing: units.gu(4)



                /*
                Label {
                      text: i18n.tr("Guardar Parada")
                      ItemStyle.class: "title"
                }*/



                TemplateRow {
                    title: i18n.tr("Titulo")

                    TextField {
                         id: inputTitulo
                         hasClearButton: true
                    }
                   }

                TemplateRow {
                    title: i18n.tr("Descripcion")
                    height: inputDescripcion.height

                    TextArea {
                         id: inputDescripcion
                         textFormat:TextEdit.RichText
                         text: longText

                    }
                 }


                TemplateRow {

                    height: botonGuardar.height

                    Button {
                        id:botonGuardar
                        text: i18n.tr("Guardar")
                        width: units.gu(12)
                        onClicked: {
                            guardarFavorito(inputTitulo.text, inputDescripcion.displayText);
                            inputTitulo.text = '';
                            inputDescripcion.text = '';
                            pageStack.pop();
                        }
                    }
                 }




            }

        }



        Page {

            id: paginaFavoritos
            title: i18n.tr("Favoritos")
            Component.onCompleted: cargarFavoritos();
            visible: false



            Column {

                spacing: units.gu(1)
                anchors {
                    margins: units.gu(2)
                    fill: parent
                }


                Label {
                    id: listadoVacioFavoritos
                    anchors.centerIn: parent
                    text: i18n.tr("Sin resultados")
                    visible: false
                }



                ListView{
                    id:listadoFavoritos
                    width: parent.width
                    height: parent.height - units.gu(10)
                    model: favoritosList
                    delegate: ListItem.Subtitled{
                        id: item1
                        text: parada + " - " + titulo
                        subText: descripcion

                        removable: true

                        backgroundIndicator: RemovableBG {
                            state: item1.swipingState
                        }

                        progression: true

                        onItemRemoved: {

                            var favoritoId = favoritosList.get(index).rowid;

                            if(favoritosList.get(index).operacion === "borrar"){
                                borrarFavorito(favoritoId);
                            }else if(favoritosList.get(index).operacion === "modificar"){

                                inputTitulo.text = favoritosList.get(index).titulo;
                                inputDescripcion.text = favoritosList.get(index).descripcion;

                                modificarFavorito = favoritosList.get(index).rowid;
                                paradaModificar = favoritosList.get(index).parada;

                                pageStack.push(formGuardar);

                                //Devuelve a la lista
                                favoritosList.append({"parada": favoritosList.get(index).parada, "titulo": favoritosList.get(index).titulo, "descripcion": favoritosList.get(index).descripcion, "rowid": favoritosList.get(index).rowid});


                            }



                        }

                        onSwipingStateChanged: {

                            if(item1.swipingState == "SwipingRight"){
                                favoritosList.get(index).operacion = "modificar";
                            }else  if(item1.swipingState == "SwipingLeft"){
                                favoritosList.get(index).operacion = "borrar";
                            }

                        }

                        onClicked: {

                            var favoritoParada = favoritosList.get(index).parada;

                            paradaActual = favoritoParada;
                            entradaParada.text = paradaActual;
                            paradaSeleccionada();

                            pageStack.push(paginaTiempos);


                        }


                    }

                }

            }

        }



        Page {
                title: i18n.tr("Acerca de")
                id: acercade
                visible: false

                Loader{
                    anchors.centerIn: parent
                    source:"AcercaDe.qml"
                }


            }


        Page {


            title: i18n.tr("Buscador")
            id: buscador
            visible: false


            Column {

                spacing: units.gu(1)
                anchors {
                    margins: units.gu(2)
                    fill: parent
                }



                                ListItem.Header { text: i18n.tr("Lineas") }


                                ListView{
                                    id:listadoLineas
                                    width: parent.width
                                    height: parent.height - units.gu(10)
                                    model: lineasList
                                    delegate: ListItem.Subtitled{

                                        text: linea
                                        subText: descripcion

                                        onClicked: cargarParadas("PRUEBA")

                                    }

                                }


                            }





        }











}


    Component {
        id: actionSelectionPopover

        ActionSelectionPopover {
            actions: ActionList {
                Action {
                    text: i18n.tr("Guardar")
                    onTriggered: pageStack.push(formGuardar)

                }
                Action {
                    text: i18n.tr("Acerca de")
                    onTriggered: pageStack.push(acercade)
                }

            }
        }
    }




    /** MODELOS DE LISTADOS **/

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

        function getParada(idx){
            return (idx >= 0 && idx < count) ? get(idx).parada: ""
        }

        function getRuta(idx){
            return (idx >= 0 && idx < count) ? get(idx).ruta: ""
        }

        function getMinutos1(idx){
            return (idx >= 0 && idx < count) ? get(idx).minutos1: ""
        }

        function getDestino() {
            //return (idx >= 0 && idx < count) ? get(idx).currency: ""
            return ""
        }




    }

    //Modelo para listado de favoritos
    ListModel {
        id: favoritosList
        ListElement {
            parada: ""
            titulo: ""
            descripcion: ""
            rowid: 0
            operacion: ""

        }

    }

    //Modelo para listado de lineas
    ListModel {
        id: lineasList
        ListElement {
            linea: "prueba"
            descripcion: "desc1"


        }

    }

    //Modelo para listado de paradas
    ListModel {
        id: paradasList
        ListElement {
            parada: "prueba"
            descripcion: "desc1"


        }

    }


    /** VARIOS **/

    //Indicador de actividad
    ActivityIndicator {
        anchors.centerIn: parent
        //running:  .s tiemposParada.status === XmlListModel.Loading

        id: actividad
    }


    //Barra de progreso
    ProgressBar {
            id: indeterminateBar
            indeterminate: true
            visible: false
            anchors.centerIn: parent


    }

    function showRequestInfo(text){


        console.log(text)

    }


    /** GESTION DE TIEMPOS **/



    //Carga inicial al entrar en la aplicacion
    function cargaInicial(){

        entradaParada.text = paradaActual;
        paradaSeleccionada();

    }


    /*
     * Seleccion de parada
    */
    function paradaSeleccionada(){

        var parada = entradaParada.text;

        tituloParada.text = i18n.tr("Parada: ") + parada;

        cargarTiempos(parada);

        hora.text = Qt.formatTime(new Date(),"hh:mm");


        if(tiempos.count < 1){
            //listadoVacio.visible=true;
        }

        paradaActual = entradaParada.text;

    }

    /*
    * Formatea los tiempos de salida
    */
    function formatearTiempos(minutos1, minutos2){

        var dato = '';

        if(minutos1 !== '0'){

            //Tiempo
            dato+= minutos1 + " " + i18n.tr("min.");

            //Hora
            var dateTime = new Date();
            var minutos1Int = parseInt(minutos1);
            dateTime.setMinutes(new Date().getMinutes() + minutos1Int);
            dato+= " (" + Qt.formatTime(dateTime,"hh:mm") + ")"

        }else{
            dato+= i18n.tr("En la parada")
        }

        if(minutos2 !== '-1'){

            dato+= " " + i18n.tr("y") +  " " + minutos2 + " " + i18n.tr("min.")

            //Hora
            var dateTime2 = new Date();
            var minutos2Int = parseInt(minutos2);
            dateTime2.setMinutes(new Date().getMinutes() + minutos2Int);
            dato+= " (" + Qt.formatTime(dateTime2,"hh:mm") + ")"

        }else{
            dato+= i18n.tr("y") + " " + i18n.tr("Sin estimacion")
        }


        return dato;
    }



    function cargarTiempos(parada){

        console.log("cargar tiempos parada: " + parada);

        indeterminateBar.visible = true;

        tiempos.clear();


        var doc = new XMLHttpRequest();

        doc.open("POST", "http://isaealicante.subus.es/services/dinamica.asmx", true);

        var sr = '<?xml version="1.0" encoding="utf-8"?>'+
                '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'+
                '<soap:Body>'+
                '<GetPasoParada xmlns="http://tempuri.org/">'+
                //'<linea>24</linea>'+
                //'<parada>4450</parada>'+
                '<parada>'+ parada + '</parada>'+
                '<status>0</status>'+
                '</GetPasoParada>'+
                '</soap:Body>'+
                '</soap:Envelope>'


        console.log(sr);

        doc.onreadystatechange = function(){

            if(doc.readyState === XMLHttpRequest.HEADERS_RECEIVED){
                showRequestInfo("Headers: ");
                showRequestInfo(doc.getAllResponseHeaders());
                showRequestInfo("last modified: ");
                showRequestInfo(doc.getResponseHeader("Last-Modified"));



            }else if(doc.readyState === XMLHttpRequest.DONE){

                showRequestInfo("salida: " + doc.responseText);

                var a = doc.responseXML.documentElement;
                for(var ii = 0; ii<a.childNodes[0].childNodes[0].childNodes[0].childNodes.length;++ii){

                    //PasoParada
                    var pasoParada = a.childNodes[0].childNodes[0].childNodes[0].childNodes[ii];

                    //e1
                    var minutos1 = pasoParada.childNodes[1].childNodes[0].childNodes[0].nodeValue;

                    //e1
                    var minutos2 = pasoParada.childNodes[2].childNodes[0].childNodes[0].nodeValue;

                    //linea
                    var linea = pasoParada.childNodes[3].childNodes[0].nodeValue;

                    //parada
                    var parada = pasoParada.childNodes[4].childNodes[0].nodeValue;

                    //ruta
                    var ruta = pasoParada.childNodes[5].childNodes[0].nodeValue;


                    showRequestInfo("Node: " + parada + linea + ruta + minutos1 + minutos2);

                    tiempos.append({"parada": parada, "linea": linea, "ruta": ruta, "minutos1": minutos1, "minutos2": minutos2});

                }

                showRequestInfo("prueba: " + tiempos.getParada(1));

                showRequestInfo("DONE: Headers: ");
                showRequestInfo(doc.getAllResponseHeaders());
                showRequestInfo("last modified: ");
                showRequestInfo(doc.getResponseHeader("Last-Modified"));



            }




            indeterminateBar.visible = false;
        }


        doc.setRequestHeader('Content-Type','text/xml; charset=utf-8');

        doc.send(sr);

    }


    /** GESTION DE FAVORITOS  **/


    //Guardar favorito en la base de datos
    function guardarFavorito(titulo, descrip) {

        //.local/share/Qt Project/QtQmlViewer/QML/OfflineStorage/Databases

        var db = LocalStorage.openDatabaseSync("TiempoBusFavoritosDB", "1.0", "Base de datos de favoritos", 1000000);

        db.transaction(
                    function(tx) {
                        // Create the database if it doesn't already exist
                        tx.executeSql('CREATE TABLE IF NOT EXISTS Favoritos(parada TEXT, titulo TEXT, descripcion TEXT)');

                        //Modificar o crear nuevo
                        if(modificarFavorito ===''){

                            // Add (another) greeting row
                            tx.executeSql('INSERT INTO Favoritos VALUES(?, ?, ?)', [ paradaActual, titulo, descrip ]);

                        }else if(modificarFavorito !==''){

                            tx.executeSql('UPDATE Favoritos SET parada = ?, titulo = ?, descripcion = ? WHERE rowid = ?', [ paradaModificar, titulo, descrip, modificarFavorito ]);

                            modificarFavorito = '';

                            cargarFavoritos();

                        }



                    }
                    )
    }


    //Cargar la lista de favoritos
    function cargarFavoritos(){

        favoritosList.clear();

        var db = LocalStorage.openDatabaseSync("TiempoBusFavoritosDB", "1.0", "Base de datos de favoritos", 1000000);

        db.transaction(
                    function(tx) {

                        // Show all added greetings
                        var rs = tx.executeSql('SELECT ROWID,* FROM Favoritos');

                        var r = ""
                        for(var i = 0; i < rs.rows.length; i++) {

                            favoritosList.append({"parada": rs.rows.item(i).parada, "titulo": rs.rows.item(i).titulo, "descripcion": rs.rows.item(i).descripcion, "rowid": rs.rows.item(i).rowid});

                            //console.log(rs.rows.item(i).rowid);

                        }
                    }
                    )

    }

    //Borrar favorito de la base de datos
    function borrarFavorito(favoritoId){

        var db = LocalStorage.openDatabaseSync("TiempoBusFavoritosDB", "1.0", "Base de datos de favoritos", 1000000);

        db.transaction(
                    function(tx) {

                        // Show all added greetings
                        tx.executeSql('DELETE FROM Favoritos WHERE ROWID=' + favoritoId);

                    }

                    )

    }



/** BUSCADOR DE PARADAS**/


    function cargarParadas(linea){

        //console.log("cargar tiempos parada: " + parada);

        indeterminateBar.visible = true;

        paradasList.clear();


        var doc = new XMLHttpRequest();

        doc.open("GET", "http://www.subus.es/Lineas/kml/ALC21ParadasIda.xml", true);


        doc.onreadystatechange = function(){

            if(doc.readyState === XMLHttpRequest.HEADERS_RECEIVED){
                showRequestInfo("Headers: ");
                showRequestInfo(doc.getAllResponseHeaders());
                showRequestInfo("last modified: ");
                showRequestInfo(doc.getResponseHeader("Last-Modified"));



            }else if(doc.readyState === XMLHttpRequest.DONE){

                showRequestInfo("salida: " + doc.responseText);

                var a = doc.responseXML.documentElement;

                for(var ii = 0; ii<a.childNodes[1].childNodes[15].childNodes.length;++ii){

                    //console.debug("nodo: " + a.childNodes[1].childNodes[15].childNodes[ii].nodeName);
                    if(a.childNodes[1].childNodes[15].childNodes[ii].nodeName === 'Placemark'){
                        console.debug("nodo: " + a.childNodes[1].childNodes[15].childNodes[ii].childNodes[1].childNodes[0].nodeValue);
                        console.debug("nodo desc: " + a.childNodes[1].childNodes[15].childNodes[ii].childNodes[3].childNodes[0].nodeValue);
                    }

                }
                //console.debug("nodo: " + a.childNodes[1].childNodes[15].childNodes[5].nodeName);

                //console.debug("nodo: " + a.childNodes[1].childNodes[15].childNodes[5].nodeName);


                /*for(var ii = 0; ii<a.childNodes[0].childNodes[0].childNodes[0].childNodes.length;++ii){

                    //PasoParada
                    var pasoParada = a.childNodes[0].childNodes[0].childNodes[0].childNodes[ii];

                    //e1
                    var minutos1 = pasoParada.childNodes[1].childNodes[0].childNodes[0].nodeValue;

                    //e1
                    var minutos2 = pasoParada.childNodes[2].childNodes[0].childNodes[0].nodeValue;

                    //linea
                    var linea = pasoParada.childNodes[3].childNodes[0].nodeValue;

                    //parada
                    var parada = pasoParada.childNodes[4].childNodes[0].nodeValue;

                    //ruta
                    var ruta = pasoParada.childNodes[5].childNodes[0].nodeValue;


                    showRequestInfo("Node: " + parada + linea + ruta + minutos1 + minutos2);

                    tiempos.append({"parada": parada, "linea": linea, "ruta": ruta, "minutos1": minutos1, "minutos2": minutos2});

                }*/

               /* showRequestInfo("prueba: " + tiempos.getParada(1));
*/
                showRequestInfo("DONE: Headers: ");
                showRequestInfo(doc.getAllResponseHeaders());
                showRequestInfo("last modified: ");
                showRequestInfo(doc.getResponseHeader("Last-Modified"));



            }




            indeterminateBar.visible = false;
        }


        doc.setRequestHeader('Content-Type','text/xml; charset=utf-8');

        doc.send();

    }



    }
