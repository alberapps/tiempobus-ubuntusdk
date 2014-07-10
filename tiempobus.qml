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
import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Components 1.1 as Toolkit
import "components"
import Ubuntu.Components.Popups 1.0
import QtQuick.XmlListModel 2.0
import QtQuick.LocalStorage 2.0
import "Utilidades.js" as Utilidades

import QtQuick.Window 2.1

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the .desktop filename

    /////Para paquete click - Cambiar
    //applicationName: "com.ubuntu.developer.alberapps.tiempobus"

    //Desktop - Quitar para paquete click
    applicationName: "tiempobus"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    width: units.gu(100)
    height: units.gu(80)

    property string paradaActual: '4450';

    property string modificarFavorito: '';
    property string paradaModificar: '';

    property string paradaIndex: '';
    property string lineaIndex: '';


    property variant preferencias:{'paradaInicial':'4450', 'cargaAutomatica': 'false'};

    /*Window.ON.close: {


            //guardarPreferencias();

             console.log("--------------CERRAR");


    }*/



    //headerColor: "#464646"
      // backgroundColor: "#797979"
      // footerColor: "#808080"

    PageStack {
            id: pageStack

            Component.onCompleted: {
                //Para desktop Quitar para crear click
                i18n.domain = 'tiempobus'
                i18n.bindtextdomain("tiempobus","/usr/share/locale")
                //Fin para desktop
                push(tabs)
            }


    //Timer para la automatica de tiempos
    Timer {
        id:timerTiempos
        interval: 60000; running: false; repeat: true
        onTriggered: {

            console.debug("Recarga automatica");
            paradaSeleccionada();
        }
    }




    Tabs {
        id: tabs

        Tab {
            id:tabPrincipal
            title: i18n.tr("TiempoBus")
            page: Page {

                id: paginaTiempos

                Component.onCompleted: cargaInicial();

                Column {
                    id:columna1
                    spacing: units.gu(1)
                    anchors {
                        margins: units.gu(2)
                        fill: parent
                    }

                    //Formulario de datos
                    Row {
                        anchors.fill: parent
                        id: entradaDatos

                        width: hora1.width + hora.width + entradaParada.width + botonTiempos.width

                        Label {
                            id: tituloParada
                            text: i18n.tr("Bus Stop: ")
                        }

                        Label {
                            id: hora1
                            anchors.top: tituloParada.bottom
                            text: i18n.tr("Updated at: ")

                        }

                        Label {
                            id: hora
                            anchors.top: tituloParada.bottom
                            anchors.left: hora1.right
                            text: "00:00"

                        }

                        TextField {
                            id: entradaParada
                            placeholderText: i18n.tr("Bus stop")

                            maximumLength: 4
                            width: units.gu(8)


                            anchors.left: hora.right
                            anchors.leftMargin: units.gu(2)

                            validator: IntValidator{bottom: 1; top: 5000;}
                            focus: true




                        }

                        Button {
                            id: botonTiempos
                            text: i18n.tr("Load")
                            onClicked: paradaSeleccionada()
                            anchors.left: entradaParada.right
                            anchors.leftMargin: units.gu(2)



                        }

                    }


                    Row {


                            Label {
                                id: listadoVacio
                                anchors.centerIn: parent
                                text: ">>" + i18n.tr("No information") +"\n" + i18n.tr("Check the Bus Timetable") + "\n\n" + i18n.tr("This application is UNofficial and its development is independent.\nLines and times data offered and maintained by: subus.es\nDevelopment: alberapps.blogspot.com - twitter.com/alberapps")
                                fontSize: "small"
                                width: parent.width
                                //anchors.margins: units.gu(100)
                                wrapMode: "Wrap"
                                visible: false

                            }


                        anchors.fill: parent

                        //Cuando no hay datos a mostrar
                        /*Label {
                            id: listadoVacio
                            anchors.centerIn: parent

                            text: i18n.tr("No information") + "\n" + i18n.tr("This application is UNofficial and its development is independent. Lines and times data offered and maintained by: subus.esDevelopment: alberapps.blogspot.com - twitter.com/alberapps")
                            visible: false



                        }*/

                    }

                    //Listado de tiempos
                    Row {
                            anchors.fill: parent
                            anchors.topMargin: units.gu(5)




                            //Listado
                            ListView{
                                id:listadoTiempos
                                anchors.top: entradaDatos.bottom
                                width: parent.width
                                height: parent.height - units.gu(10)
                                model: tiempos
                                delegate: ListItem.Subtitled{
                                    text: linea + " - " + ruta
                                    subText: formatearTiempos(minutos1,minutos2)

                                    onClicked: {
                                        console.debug('tiempo seleccionado');
                                    }
                                }


                                footer: ListItem.Subtitled{

                                    text: i18n.tr("Notice")
                                    subText: i18n.tr("This application is UNofficial and its development is independent.\nLines and times data offered and maintained by: subus.es\nDevelopment: alberapps.blogspot.com - twitter.com/alberapps")

                                }

                            }


                            }



                }


                tools: ToolbarItems {

                            ToolbarButton {
                                action: Action {
                                    text: i18n.tr("Save")
                                    iconName: "favorite-unselected"
                                    onTriggered: {modificarFavorito = '';
                                        paradaModificar = paradaActual;
                                        pageStack.push(formGuardar);}
                                }

                            }


                            ToolbarButton {
                                text: i18n.tr("Settings")
                                iconName: "settings"
                                onTriggered: pageStack.push(acercade)

                            }

                            locked: false
                            opened: true
                        }


            }


        }
        Tab {
            id: tabFavoritos
            title: i18n.tr("Favorites")
            onVisibleChanged: {

                if(tabFavoritos.visible){
                    cargarFavoritos();
                }


            }

            //Listado de favoritos
            page: Page {

                id: paginaFavoritos
                //Component.onCompleted: cargarFavoritos();



                Column {

                    spacing: units.gu(1)
                    anchors {
                        margins: units.gu(2)
                        fill: parent
                    }


                    Label {
                        id: listadoVacioFavoritos
                        anchors.centerIn: parent
                        text: i18n.tr("No information")
                        visible: false
                    }


                    Component {
                        id: dialogFavorito

                        //Opciones al seleccionar el favorito

                        ActionSelectionPopover {
                            id: dialogue
                            delegate: ListItem.Standard {
                              text: action.text

                            }
                            actions: ActionList {
                              Action {
                                  text: i18n.tr("Load")
                                  onTriggered: {
                                      PopupUtils.close(dialogue);

                                      var favoritoParada = favoritosList.get(paradaIndex).parada;
                                      paradaActual = favoritoParada;

                                      entradaParada.text = paradaActual;
                                      paradaSeleccionada();

                                      //Tab principal
                                      tabs.selectedTabIndex = 0;
                                  }
                              }
                              Action {
                                  text: i18n.tr("Modify")
                                  onTriggered: {

                                      PopupUtils.close(dialogue);

                                      inputTitulo.text = favoritosList.get(paradaIndex).titulo;
                                      inputDescripcion.text = favoritosList.get(paradaIndex).descripcion;

                                      modificarFavorito = favoritosList.get(paradaIndex).rowid;
                                      paradaModificar = favoritosList.get(paradaIndex).parada;

                                      pageStack.push(formGuardar);

                                      //Devuelve a la lista
                                      favoritosList.append({"parada": favoritosList.get(paradaIndex).parada, "titulo": favoritosList.get(paradaIndex).titulo, "descripcion": favoritosList.get(paradaIndex).descripcion, "rowid": favoritosList.get(paradaIndex).rowid});

                                  }
                              }
                              Action {
                                  text: i18n.tr("Delete")
                                  onTriggered: {
                                      PopupUtils.close(dialogue);

                                       var favoritoId = favoritosList.get(paradaIndex).rowid;

                                      borrarFavorito(favoritoId);

                                      cargarFavoritos();


                                  }
                              }
                            }
                        }



                    }



                    //Listado de favoritos
                    ListView{
                        id:listadoFavoritos
                        width: parent.width
                        height: parent.height - units.gu(10)
                        model: favoritosList
                        delegate: ListItem.Subtitled{
                            id: item1
                            text: parada + " - " + titulo
                            subText: descripcion


                            onClicked: {


                                paradaIndex = index;

                                PopupUtils.open(dialogFavorito, null);





                            }


                        }

                    }



                }

            }



        }
        Tab {
            title: i18n.tr("Search")
            page: Page {

                id: buscador

                Component.onCompleted: cargarLineas();

                Column {

                    spacing: units.gu(1)
                    anchors {
                        margins: units.gu(2)
                        fill: parent
                    }



                    //ListItem.Header { text: i18n.tr("Lineas") }


                    Component {
                        id: dialogBuscador

                        Dialog {
                            id: dialogue


                            title: i18n.tr("Options")
                            //text: "Are you sure you want to delete this file?"

                            Button {
                                text: "Ida"
                                gradient: UbuntuColors.greyGradient
                                onClicked: {
                                    PopupUtils.close(dialogue);

                                    cargarParadas(lineasList.get(paradaIndex).linea, "ida");

                                    headerParadas.text = i18n.tr("Forward");


                                    pageStack.push(buscadorParadasIda);


                                }

                            }
                            Button {
                                text: "Vuelta"
                                onClicked: {

                                    PopupUtils.close(dialogue);

                                    cargarParadas(lineasList.get(paradaIndex).linea, "vuelta");

                                    headerParadas.text = i18n.tr("Backward");

                                    pageStack.push(buscadorParadasIda);

                                }

                            }

                            Button {
                                text: "Cancel"
                                onClicked: PopupUtils.close(dialogue)
                            }
                        }
                    }


                    //Formulario de datos
                    Row {
                        //anchors.fill: parent
                        id: entradaDatos2

                        //width: hora1.width + hora.width + entradaParada.width + botonTiempos.width



                        Button {
                            id: botonCargarFav
                            text: i18n.tr("Load")
                            anchors.leftMargin: units.gu(5)
                            color: UbuntuColors.warmGrey
                            enabled: false

                            onClicked:{

                                var favoritoParada = paradasList.get(paradaIndex).parada;

                                paradaActual = favoritoParada;
                                entradaParada.text = paradaActual;
                                paradaSeleccionada();

                                //Tab principal
                                tabs.selectedTabIndex = 0;
                            }


                        }

                    }



                    ListItem.ItemSelector{
                         model: lineasList
                         id:itemLineas
                         //text: i18n.tr("Lineas")
                         delegate: selectorDelegate




                         onDelegateClicked:  {

                             //itemSentido.selectedIndex = 1;

                             lineaIndex = index;

                             if(lineaIndex === 0){

                                 //No seleccionado

                             }else if(itemSentido.selectedIndex === 0){

                                cargarParadas(lineasList.get(lineaIndex).linea, "ida");

                             }else{

                                 cargarParadas(lineasList.get(lineaIndex).linea, "vuelta");

                             }



                         }



                    }


                    Component {
                        id: selectorDelegate
                        Toolkit.OptionSelectorDelegate {
                            text: {
                                if(linea != "-1"){
                                    linea
                                }else{
                                    i18n.tr("Select Bus Line")
                                }
                            }
                            subText: {
                                if(linea != "-1"){
                                    descripcion
                                }else{
                                    ''
                                }

                            }
                        }



                    }


                    OptionSelector {
                       id:itemSentido
                       //objectName: "sentido"
                       //text: i18n.tr("Sentido")

                       model: [i18n.tr("Forward"),
                               i18n.tr("Backward")]

                       onDelegateClicked: {
                           if(lineaIndex !== 0){
                            if(index === 0){
                                   cargarParadas(lineasList.get(lineaIndex).linea, "ida");
                            }else{
                               cargarParadas(lineasList.get(lineaIndex).linea, "vuelta");

                            }
                           }


                       }

                    }





                    ListItem.ItemSelector{
                         model: paradasList
                         id:itemParadas
                         //text: i18n.tr("Paradas")
                         delegate: selectorDelegateParada




                         onDelegateClicked:  {

                             if(paradasList.get(index).parada !== '-1'){
                                paradaIndex = index;

                                botonCargarFav.enabled = true;
                                botonCargarFav.color = UbuntuColors.orange;

                             }else{
                                 botonCargarFav.enabled = false;
                                 botonCargarFav.color = UbuntuColors.warmGrey;

                             }


                         }



                    }


                    Component {
                        id: selectorDelegateParada
                        Toolkit.OptionSelectorDelegate {
                            text: {
                                if (parada != '-' && parada != -1){
                                    parada + " - " + direccion
                                }else{
                                    i18n.tr("Select Bus Stop")
                                }
                            }
                            subText:{
                                if(parada != '-' && parada != -1){
                                    " T: " + lineas
                                }

                            }
                        }



                    }

                }





            }

        }
    }

    //Pagina de nuevo favorito
    Page {
        title: i18n.tr("Save")
        id: formGuardar
        visible: false


        Column {
            id: pageLayout

            anchors {
                fill: parent
                margins: units.gu(5)


            }
            spacing: units.gu(4)


            TemplateRow {
                title: i18n.tr("Label")

                TextField {
                    id: inputTitulo
                    hasClearButton: true
                }
            }

            TemplateRow {
                title: i18n.tr("Description")
                height: inputDescripcion.height

                TextArea {
                    id: inputDescripcion
                    textFormat:TextEdit.RichText
                    //text: longText

                }
            }


            TemplateRow {

                height: botonGuardar.height

                Button {
                    id:botonGuardar
                    text: i18n.tr("Save")
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
        title: i18n.tr("Settings")
        id: acercade
        visible: false
        Component.onCompleted: {
            cargarPreferencias();

            if(preferencias.cargaAutomatica === "true"){
                console.debug('SI');
                confCargaAuto.checked = true;
            }else{
                console.debug('NO: ' + preferencias.cargaAutomatica);
                confCargaAuto.checked = false;
            }
        }






        Flickable{

            //anchors.top: texto5.bottom

            id:flick

            flickableDirection: Flickable.VerticalFlick
            anchors.fill: parent
            contentWidth: parent.width
            contentHeight: parent.height


            ListItem.Standard {
                id: listadoPreferencias
                    text: i18n.tr("Automatic Refresh")
                    control: Toolkit.Switch {
                        id: confCargaAuto
                        anchors.verticalCenter: parent.verticalCenter

                        onClicked: {
                            console.log('PREFERENCIAS CAMBIADA: ' + confCargaAuto.checked);

                            var temp = preferencias;

                            if(confCargaAuto.checked){
                                temp.cargaAutomatica = 'true';
                                console.log('OK');
                            }else{
                                temp.cargaAutomatica = 'false';
                                console.log('NOOK');
                            }

                            preferencias = temp;

                            guardarPreferencias();

                        }
                    }
                }

        Column {
            id:listadoLabel
            anchors.top: listadoPreferencias.bottom
            spacing: units.gu(0.5)
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                id: imagen
                anchors.horizontalCenter: parent.horizontalCenter

                source: Qt.resolvedUrl("ic_tiempobus_3-web.png")
                width: units.gu(10)
                height: units.gu(10)

            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "TiempoBus 0.7 BETA"
                fontSize: "x-large"
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Alberto Montiel 2014"
                fontSize: "large"
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: i18n.tr("This is a BETA version.")
                fontSize: "medium"
            }

            WebLink{
                anchors.horizontalCenter: parent.horizontalCenter
                id: texto4
                label: "http://alberapps.blogspot.com"
                url: "http://alberapps.blogspot.com"
            }

            WebLink{
                anchors.horizontalCenter: parent.horizontalCenter
                id: texto5
                label: i18n.tr("License GPLv3")
                url: "http://www.gnu.org/licenses/gpl.html"
            }



            Label {

                anchors.horizontalCenter: parent.horizontalCenter
                text: "\n\n" + i18n.tr("TiempoBus - Informacion sobre tiempos de paso de autobuses en Alicante\nCopyright (C) 2014 Alberto Montiel\n\nThis program is free software: you can redistribute it and/or modify\nit under the terms of the GNU General Public License as published by\nthe Free Software Foundation, either version 3 of the License, or\n(at your option) any later version.\n\nThis program is distributed in the hope that it will be useful,\nbut WITHOUT ANY WARRANTY; without even the implied warranty of\nMERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\nGNU General Public License for more details.\n\nYou should have received a copy of the GNU General Public License\nalong with this program.  If not, see <http://www.gnu.org/licenses/>.")
                fontSize: "x-small"
                //wrapMode: Label.Wrap
                //width: parent.width - units.gu(20)

            }

        }












    }



       /* Scrollbar {
                flickableItem: flick
                align: Qt.AlignTrailing
            }
*/

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
        linea: "-1"
        descripcion: ""
        operacion: ""

    }

}

//Modelo para listado de paradas
ListModel {
    id: paradasList
    ListElement {
        parada: "-1"
        descripcion: ""
        lineas: ""
        sentido: ""
        direccion: ""


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




/** GESTION DE TIEMPOS **/



//Carga inicial al entrar en la aplicacion
function cargaInicial(){

    //Carga inicial de preferencias
    cargarPreferencias();
    paradaActual = preferencias.paradaInicial;

    //Fin carga preferencias

    //Inicializar
    entradaParada.text = paradaActual;


    paradaSeleccionada();


    //Carga automatica segun preferencias
    if(preferencias.cargaAutomatica === "true"){
        timerTiempos.running = true;

        console.debug("Iniciada carga automatica");
    }

    console.debug("valor automatica: " + preferencias.cargaAutomatica);

}


/*
 * Seleccion de parada
*/
function paradaSeleccionada(){

    var parada = entradaParada.text;

    tituloParada.text = i18n.tr("Bus Stop: ") + parada;

    cargarTiempos(parada);

    hora.text = Qt.formatTime(new Date(),"hh:mm");



    paradaActual = entradaParada.text;

    //Guardar en preferencias
    //console.log('PREFERENCIAS A GUARDAR: ' + paradaActual);
    //preferencias.paradaInicial = paradaActual;
    guardarPreferencias();
    console.log('PREFERENCIAS SELECCIONADA: ' + preferencias.paradaInicial);

}

/*
* Formatea los tiempos de salida
*/
function formatearTiempos(minutos1, minutos2){

    var dato = '';

    if(minutos1 !== '0'){

        //Tiempo
        dato+= minutos1 + " " + i18n.tr("min");

        //Hora
        var dateTime = new Date();
        var minutos1Int = parseInt(minutos1);
        dateTime.setMinutes(new Date().getMinutes() + minutos1Int);
        dato+= " (" + Qt.formatTime(dateTime,"hh:mm") + ")"

    }else{
        dato+= i18n.tr("At bus stop")
    }

    if(minutos2 !== '-1'){

        dato+= " " + i18n.tr("and") +  " " + minutos2 + " " + i18n.tr("min")

        //Hora
        var dateTime2 = new Date();
        var minutos2Int = parseInt(minutos2);
        dateTime2.setMinutes(new Date().getMinutes() + minutos2Int);
        dato+= " (" + Qt.formatTime(dateTime2,"hh:mm") + ")"

    }else{
        dato+= " " + i18n.tr("and") + " " + i18n.tr("No data")
    }


    return dato;
}


//Carga la lista de tiempos de la parada
function cargarTiempos(parada){

    console.debug("cargar tiempos parada: " + parada);

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


    console.debug(sr);

    doc.onreadystatechange = function(){

        if(doc.readyState === XMLHttpRequest.HEADERS_RECEIVED){
            console.debug("Headers: ");
            console.debug(doc.getAllResponseHeaders());
            console.debug("last modified: ");
            console.debug(doc.getResponseHeader("Last-Modified"));



        }else if(doc.readyState === XMLHttpRequest.DONE){

            console.debug("salida: " + doc.responseText);

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


                console.debug("Node: " + parada + linea + ruta + minutos1 + minutos2);

                tiempos.append({"parada": parada, "linea": linea, "ruta": ruta, "minutos1": minutos1, "minutos2": minutos2});

            }

            console.debug("prueba: " + tiempos.getParada(1));

            console.debug("DONE: Headers: ");
            console.debug(doc.getAllResponseHeaders());
            console.debug("last modified: ");
            console.debug(doc.getResponseHeader("Last-Modified"));



        }




        indeterminateBar.visible = false;

        console.debug("tiem: " + tiempos.count)

        if(tiempos.count < 1){
            listadoVacio.visible=true;
            listadoTiempos.visible=false
        }else{
            listadoVacio.visible=false;
            listadoTiempos.visible=true;
        }

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


    if(favoritosList.count < 1){
        listadoVacioFavoritos.visible=true;
    }else{
        listadoVacioFavoritos.visible=false;
    }

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

    if(favoritosList.count < 1){
        listadoVacioFavoritos.visible=true;
    }else{
        listadoVacioFavoritos.visible=false;
    }

}



/** BUSCADOR DE PARADAS**/

//Carga la lista de lineas
function cargarLineas(){

    lineasList.clear();

    //default
    lineasList.append({"linea": "-1", "descripcion": i18n.tr("Select Bus Line")});
    //Opcion por defecto
    paradasList.append({"parada": "-1", "descripcion": i18n.tr("Select Bus Stop"), "lineas": "-", "sentido": "-", "direccion": i18n.tr("Select Bus Stop")});



    for(var i = 0;i<lineasNum.length;i++){

        lineasList.append({"linea": lineasNum[i], "descripcion": lineasDescripcion[i]});

    }




}


//Cargar la lista de paradas del sentido indicado
function cargarParadas(linea, sentido){


    //cargarParadasNuevo(linea, sentido);


    //console.log("cargar tiempos parada: " + parada);

    indeterminateBar.visible = true;

    paradasList.clear();

    //Opcion por defecto
    paradasList.append({"parada": "-1", "descripcion": i18n.tr("Select Bus Stop"), "lineas": "-", "sentido": "-", "direccion": i18n.tr("Select Bus Stop")});

    var url = generarUrlLineaNuevo(linea);

    var doc = new XMLHttpRequest();

    doc.open("GET", url, true);


    doc.onreadystatechange = function(){

        if(doc.readyState === XMLHttpRequest.HEADERS_RECEIVED){
            /*console.debug("Headers: ");
            console.debug(doc.getAllResponseHeaders());
            console.debug("last modified: ");
            console.debug(doc.getResponseHeader("Last-Modified"));
            */


        }else if(doc.readyState === XMLHttpRequest.DONE){

           // showRequestInfo("salida: " + doc.responseText);
            //console.debug(doc.responseText);


            var a = doc.responseXML.documentElement;

            //var folderPrincipalList = a.getElementsByTagName('Folder');
            var folderPrincipalList = getElementsByTagName(a, 'Folder');

            var direccionalidad = folderPrincipalList[1].childNodes[1].childNodes[0].nodeValue;

            console.debug("DIRECCIONALIDAD: " + folderPrincipalList[1].childNodes[1].childNodes[0].nodeValue);

            var folderIda;
            var folderVuelta;

            if(direccionalidad === 'Ida'){
                folderIda = folderPrincipalList[1];
                folderVuelta = folderPrincipalList[2];
            }else{
                folderIda = folderPrincipalList[2];
                folderVuelta = folderPrincipalList[1];
            }

            var items;


            if(sentido === 'ida'){
                //items = folderIda.getElementsByTagName('Placemark');
                items = getElementsByTagName(folderIda, 'Placemark')
            }else{
                //items = folderVuelta.getElementsByTagName('Placemark');
                items = getElementsByTagName(folderVuelta, 'Placemark')
            }


            var item;
            var datosPlaceMark;
            var dato;
            var etiqueta;
            var descripcion;

            for (var ii = 0; ii < items.length; ++ii) {

                item = items[ii];
                datosPlaceMark = item.childNodes;

                for (var j = 0; j < datosPlaceMark.length; ++j) {

                    dato = datosPlaceMark[j];
                    etiqueta = dato.nodeName;
                    //console.log("etiqueta: " + etiqueta);

                    if (etiqueta === "name") {
                        var direccion = dato.childNodes[0].nodeValue;
                    }

                    if(etiqueta === 'description'){

                        descripcion = dato.childNodes[0].nodeValue;
                        //console.log("valor: " + descripcion);

                        var procesaDesc = descripcion.split(" ");

                        var parada = procesaDesc[3].trim();

                        // posicion sentido
                        var sent = descripcion.indexOf("Sentido");
                        var neas = descripcion.indexOf("neas");

                        // lineas conexion
                        var lineas = descripcion.substring(neas + 5, sent).trim();

                        // Sentido
                        var sentidoRecorrido = descripcion.substring(sent + 8).trim();

                        console.debug("parada: " + parada + "lineas: " + lineas
                                + "sentido: " + sentidoRecorrido);


                            paradasList.append({"parada": parada, "descripcion": descripcion, "lineas": lineas, "sentido": sentidoRecorrido, "direccion": direccion});



                    }


                }


            }






        }




        indeterminateBar.visible = false;
    }


    doc.setRequestHeader('Content-Type','text/xml; charset=utf-8');

    doc.send();

}




//Informacione estatica de las lineas
property variant lineasDescripcion: ["21 ALICANTE-P.S.JUAN-EL CAMPELLO","22 ALICANTE-C. HUERTAS-P.S. JUAN","23 ALICANTE-SANT JOAN-MUTXAMEL","24 ALICANTE-UNIVERSIDAD-S.VICENTE","25 ALICANTE-VILLAFRANQUEZA","26 ALICANTE-VILLAFRANQUEZA-TANGEL","27 ALICANTE(O.ESPLA) - URBANOVA","30 SAN VICENTE-LA ALCORAYA","C-55 EL CAMPELLO-UNIVERSIDAD","35 ALICANTE-PAULINAS-MUTXAMEL","36 SAN GABRIEL-UNIVERSIDAD","38 P.S.JUAN-H.ST.JOAN-UNIVERSIDAD","39 EXPLANADA - C. TECNIFICACIÓN","21N ALICANTE- P.S.JUAN-EL CAMPELLO","22N ALICANTE- PLAYA SAN JUAN","23N ALICANTE-SANT JOAN- MUTXAMEL","24N ALICANTE-UNIVERSIDAD-S.VICENTE","01 S. GABRIEL-JUAN XXIII  (1ºS)","02 LA FLORIDA-SAGRADA FAMILIA","03 CIUDAD DE ASIS-COLONIA REQUENA","04 CEMENTERIO-TOMBOLA","05 EXPLANADA-SAN BLAS-RABASA","06 AV.ÓSCAR ESPLÁ - COLONIA REQUENA","07 AV.ÓSCAR ESPLÁ-EL REBOLLEDO","8A EXPLANADA -VIRGEN REMEDIO","09 AV.ÓSCAR ESPLÁ - AV. NACIONES","10 EXPLANADA - VIA PARQUE","11 V.REMEDIO-AV DENIA (JESUITAS)","11H V.REMEDIO-AV. DENIA-HOSP.ST JOAN","12 AV. CONSTITUCION-S. BLAS(PAUI)","16 PZA. ESPAÑA-MERCADILLO TEULADA","17 ZONA NORTE-MERCADILLO TEULADA","8B EXPLANADA-VIRGEN DEL REMEDIO","191 PLA - CAROLINAS - RICO PEREZ","192 C. ASIS - BENALUA - RICO PEREZ","M MUTXAMEL-URBANITZACIONS","136 MUTXAMEL - CEMENTERIO","C2 VENTA LANUZA - EL CAMPELLO","C-51 MUTXAMEL - BUSOT","C-52 BUSOT - EL CAMPELLO","C-53 HOSPITAL SANT JOAN - EL CAMPELLO","C-54 UNIVERSIDAD-HOSP. SANT JOAN","C-6 ALICANTE-AEROPUERTO","45 HOSPITAL-GIRASOLES-MANCHEGOS","46A HOSPITAL-VILLAMONTES-S.ANTONIO","46B HOSPITAL-P.CANASTELL-P.COTXETA","TURI BUS TURÍSTICO (TURIBUS)","31 MUTXAMEL-ST.JOAN-PLAYA S. JUAN","30P SAN VICENTE-PLAYA SAN JUAN","C-6* ALICANTE-URBANOVA-AEROPUERTO"];
property variant lineasCodigoKml: ["ALC21","ALC22","ALC23","ALC24","ALC25","ALC26","ALC27","ALC30","ALCC55","ALC35","ALC36","ALC38","ALC39","ALC21N","ALC22N","ALC23N","ALC24N","MAS01","MAS02","MAS03","MAS04","MAS05","MAS06","MAS07","MAS8A","MAS09","MAS10","MAS11","MAS11H","MAS12","MAS16","MAS17","MAS8B","MAS191","MAS192","MUTM","MUT136","CAMPC2","ALCC51","ALCC52","ALCC53","ALCC54","ALCC6","ALCS45","ALCS46A","ALCS46B","Turibus","ALC31","ALC30B","ALCC6"];
property variant lineasNum: ["21","22","23","24","25","26","27","30","C-55","35","36","38","39","21N","22N","23N","24N","01","02","03","04","05","06","07","8A","09","10","11","11H","12","16","17","8B","191","192","M","136","C2","C-51","C-52","C-53","C-54","C-6","45","46A","46B","TURI","31","30P","C-6*"];



//Url de consulta de la linea. Indicar el sentido de ida o vuelta
function generarUrlLinea(linea, sentido){

    var url = "http://www.subus.es/Lineas/kml/";

    var urlSufijoIda = "";

    if(sentido === "ida"){
        urlSufijoIda = "ParadasIda.xml";
    }else{
        urlSufijoIda = "ParadasVuelta.xml";
    }

    var indiceLinea = lineasNum.indexOf(linea);

    var urlIda = url + lineasCodigoKml[indiceLinea] +  urlSufijoIda;

    console.debug("urlIda: " + urlIda);



    return urlIda;

}


function generarUrlLineaNuevo(linea) {

    var url = "http://www.subus.es/K/";

    var urlSufijo = "";


    urlSufijo = "P.xml";


    var indiceLinea = lineasNum.indexOf(linea);

    var urlCompleta = url + lineasCodigoKml[indiceLinea] + urlSufijo;

    console.debug("urlIda: " + urlCompleta);

    return urlCompleta;


}


function getElementsByTagName(rootElement, tagName){

    var childNodes = rootElement.childNodes;
    var elements = [];
    for( var i = 0; i < childNodes.length;i++){

        //console.debug('nodo: ' + childNodes[i].nodeName);

        if(childNodes[i].nodeName === tagName){
            elements.push(childNodes[i]);
        }

        if(childNodes[i].childNodes.length > 0){

            elements = elements.concat(getElementsByTagName(childNodes[i], tagName));

        }

    }

    return elements;

}





//PREFERENCIAS EN BASE DE DATOS. TODO: Cambiar en proximas versiones

//Guardar preferencias
function guardarPreferencias() {

    var db = LocalStorage.openDatabaseSync("TiempoBusFavoritosDB", "1.0", "Base de datos de favoritos", 1000000);

    db.transaction(
                function(tx) {
                    //Parada inicial
                    tx.executeSql('UPDATE Preferencias SET valor = ? WHERE preferencia = \'paradaInicial\'', [ paradaActual ]);

                    //Carga Automatica
                    tx.executeSql('UPDATE Preferencias SET valor = ? WHERE preferencia = \'cargaAutomatica\'', [ preferencias.cargaAutomatica ]);

                    console.debug('Auto: ' + preferencias.cargaAutomatica);

                })
}


//Cargar preferencias
function cargarPreferencias(){

    var db = LocalStorage.openDatabaseSync("TiempoBusFavoritosDB", "1.0", "Base de datos de favoritos", 1000000);

    db.transaction(
                function(tx) {

                    var temp = preferencias;

                    // Create the database if it doesn't already exist
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Preferencias(preferencia TEXT, valor TEXT)');

                    // Preferencia parada inicial
                    var rs = tx.executeSql('SELECT ROWID,* FROM Preferencias WHERE preferencia = \'paradaInicial\'');

                    if(rs.rows.length < 1){
                        tx.executeSql('INSERT INTO Preferencias VALUES(?, ?)', [ "paradaInicial", paradaActual ]);
                    }else{
                        temp.paradaInicial = rs.rows.item(0).valor;
                    }

                    //Preferencia carga automatica
                    var rs2 = tx.executeSql('SELECT ROWID,* FROM Preferencias WHERE preferencia = \'cargaAutomatica\'');

                    if(rs2.rows.length < 1){
                        tx.executeSql('INSERT INTO Preferencias VALUES(?, ?)', [ "cargaAutomatica", "true" ]);
                    }else{
                        temp.cargaAutomatica = rs2.rows.item(0).valor;
                    }

                    preferencias = temp;

                }
                )




}














}

