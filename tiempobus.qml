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
                //anchors.topMargin: parent
                text: "Bus stop: "
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
                    text: i18n.tr("No information")
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

                    footer: ListItem.Subtitled{



                        text: i18n.tr("Aviso")


                        subText: i18n.tr("Time offered by ISAE system, which offers, in REAL TIME, the time of arrival ESTIMATES in TAM net. These times may vary for reasons unrelated to the app, as traffic, route changes, etc. Features using the local database may not show the latest route changes. This application is UNofficial and its development is independent. Line data and step times obtained from: www.subus.es and isaealicante.subus.es/movil/index.aspx\nLearn more: alberapps.blogspot.com and at Twitter: @alberapps")


                    }

                }







                Item{
                    id: entradaDatos
                    anchors.top: listadoTiempos.bottom
                    //anchors.bottomMargin: parent
                    anchors.horizontalCenter: parent.horizontalCenter


                    width: hora.width + entradaParada.width + botonTiempos.width

                    Label {
                        id: hora

                        text: "00:00"

                    }

                    TextField {
                        id: entradaParada
                        placeholderText: i18n.tr("Bus stop")

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

                Label {
                    id: avisoMenu
                    anchors.top: parent.bottom
                    text: i18n.tr("* Arrastrar arriba para desplegar el menu")

                }

            }




            tools: ToolbarActions {

                opened: true
                locked: false

                Action {
                    text: i18n.tr("Favorites")
                    iconSource: Qt.resolvedUrl("ic_menu_favoritos.png")

                    onTriggered: {
                        cargarFavoritos();
                        pageStack.push(paginaFavoritos);
                    }
                }
                Action {
                    text: i18n.tr("Save")
                    iconSource: Qt.resolvedUrl("ic_menu_guardar.png")
                    onTriggered: {modificarFavorito = '';
                        paradaModificar = paradaActual;
                        pageStack.push(formGuardar);}
                }
                Action {
                    text: i18n.tr("Search")
                    iconSource: Qt.resolvedUrl("ic_menu_ida.png")
                    onTriggered: pageStack.push(buscador)
                }
                Action {
                    text: i18n.tr("Settings")
                    iconSource: Qt.resolvedUrl("ic_menu_preferencias.png")
                    onTriggered: pageStack.push(acercade)
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



                /*
                Label {
                      text: i18n.tr("Guardar Parada")
                      ItemStyle.class: "title"
                }*/



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

            id: paginaFavoritos
            title: i18n.tr("Favorites")
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
                    text: i18n.tr("No information")
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

                Label {
                    id: avisoFavorito
                    anchors.top: parent.bottom
                    text: i18n.tr("* Click para cargar el favorito. Arrastrar derecha para Modificar. Arrastrar izquierda para Borrar")

                }


            }

        }



        Page {
            title: i18n.tr("Settings")
            id: acercade
            visible: false


            Loader{
                anchors.centerIn: parent
                source:"AcercaDe.qml"
            }


        }


        Page {


            title: i18n.tr("Search")
            id: buscador
            visible: false
            Component.onCompleted: cargarLineas();

            Column {

                spacing: units.gu(1)
                anchors {
                    margins: units.gu(2)
                    fill: parent
                }



                //ListItem.Header { text: i18n.tr("Lineas") }


                ListView{
                    id:listadoLineas
                    width: parent.width
                    height: parent.height - units.gu(10)
                    model: lineasList
                    delegate: ListItem.Standard{

                        id:itemLineas
                        text: descripcion


                        onClicked: {cargarParadas(lineasList.get(index).linea);
                            pageStack.push(buscadorParadasIda);
                        }

                        removable: true

                        backgroundIndicator: RemovableBGLineas {
                            state: itemLineas.swipingState
                        }


                        onItemRemoved: {


                            if(lineasList.get(index).operacion === "ida"){

                                cargarParadas(lineasList.get(index).linea, "ida");

                                headerParadas.text = i18n.tr("Forward");


                                pageStack.push(buscadorParadasIda);
                            }else if(lineasList.get(index).operacion === "vuelta"){

                                cargarParadas(lineasList.get(index).linea, "vuelta");

                                headerParadas.text = i18n.tr("Backward");

                                pageStack.push(buscadorParadasIda);
                            }


                            cargarLineas();

                        }

                        onSwipingStateChanged: {

                            if(itemLineas.swipingState == "SwipingRight"){
                                lineasList.get(index).operacion = "ida";
                            }else  if(itemLineas.swipingState == "SwipingLeft"){
                                lineasList.get(index).operacion = "vuelta";
                            }

                        }

                    }

                }

                Label {
                    id: avisoBuscador
                    anchors.top: parent.bottom
                    text: i18n.tr("* Arrastrar derecha para Paradas Ida. Arrastrar izquierda para Paradas Vuelta")

                }


            }





        }

        Page {


            title: i18n.tr("Search")
            id: buscadorParadasIda
            visible: false


            Column {

                spacing: units.gu(1)
                anchors {
                    margins: units.gu(2)
                    fill: parent
                }



                ListItem.Header {id: headerParadas; text: i18n.tr("Backward") }


                ListView{
                    id:listadoParadasIda
                    width: parent.width
                    height: parent.height - units.gu(10)
                    model: paradasList
                    delegate: ListItem.Subtitled{

                        text: parada + " - " + direccion
                        subText: " T: " + lineas



                        onClicked:{

                            var favoritoParada = paradasList.get(index).parada;

                            paradaActual = favoritoParada;
                            entradaParada.text = paradaActual;
                            paradaSeleccionada();

                            pageStack.push(paginaTiempos);
                        }


                    }

                }


            }





        }

    }

/*
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
*/



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
            linea: ""
            descripcion: ""
            operacion: ""

        }

    }

    //Modelo para listado de paradas
    ListModel {
        id: paradasList
        ListElement {
            parada: ""
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
         //   listadoVacio.visible=true;
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
            dato+= i18n.tr("At bus stop")
        }

        if(minutos2 !== '-1'){

            dato+= " " + i18n.tr("&") +  " " + minutos2 + " " + i18n.tr("min.")

            //Hora
            var dateTime2 = new Date();
            var minutos2Int = parseInt(minutos2);
            dateTime2.setMinutes(new Date().getMinutes() + minutos2Int);
            dato+= " (" + Qt.formatTime(dateTime2,"hh:mm") + ")"

        }else{
            dato+= i18n.tr("y") + " " + i18n.tr("No data")
        }


        return dato;
    }


    //Carga la lista de tiempos de la parada
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

    //Carga la lista de lineas
    function cargarLineas(){

        lineasList.clear();

        for(var i = 0;i<lineasNum.length;i++){

            lineasList.append({"linea": lineasNum[i], "descripcion": lineasDescripcion[i]});

        }




    }


    //Cargar la lista de paradas del sentido indicado
    function cargarParadas(linea, sentido){

        //console.log("cargar tiempos parada: " + parada);

        indeterminateBar.visible = true;

        paradasList.clear();


        var url = generarUrlLinea(linea, sentido);

        var doc = new XMLHttpRequest();

        doc.open("GET", url, true);


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

                        var direccion = a.childNodes[1].childNodes[15].childNodes[ii].childNodes[1].childNodes[0].nodeValue;

                        var descripcion = a.childNodes[1].childNodes[15].childNodes[ii].childNodes[3].childNodes[0].nodeValue;

                        var procesaDesc = descripcion.split(" ");

                        var parada = procesaDesc[3].trim();

                        //posicion sentido
                        var sent = descripcion.indexOf("Sentido");
                        var neas = descripcion.indexOf("neas");


                        //lineas conexion
                        var lineas = descripcion.substring(neas+5,sent).trim();

                        //Sentido
                        var sentido = descripcion.substring(sent+8).trim();

                        console.debug("parada: " +parada + "lineas: " + lineas + "sentido: " + sentido);

                        paradasList.append({"parada": parada, "descripcion": descripcion, "lineas": lineas, "sentido": sentido, "direccion": direccion});

                        console.debug("nodo: " + a.childNodes[1].childNodes[15].childNodes[ii].childNodes[1].childNodes[0].nodeValue);
                        console.debug("nodo desc: " + a.childNodes[1].childNodes[15].childNodes[ii].childNodes[3].childNodes[0].nodeValue);
                    }

                }

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

    //Informacione estatica de las lineas
    property variant lineasDescripcion: ["21 ALICANTE-P.S.JUAN-EL CAMPELLO","22 ALICANTE-C. HUERTAS-P.S. JUAN","23 ALICANTE-SANT JOAN-MUTXAMEL","24 ALICANTE-UNIVERSIDAD-S.VICENTE","25 ALICANTE-VILLAFRANQUEZA","26 ALICANTE-VILLAFRANQUEZA-TANGEL","27 ALICANTE-URBANOVA","30 SAN VICENTE-EL REBOLLEDO","C-55 EL CAMPELLO-UNIVERSIDAD","34 LANZADERA UNIVERSIDAD","35 ALICANTE-PAULINAS-MUTXAMEL","36 SAN GABRIEL-UNIVERSIDAD","37 PADRE ESPLA-UNIVERSIDAD","38 P.S.JUAN-H.ST.JOAN-UNIVERSIDAD","39 EXPLANADA - C. TECNIFICACIÓN","21N ALICANTE- P.S.JUAN-EL CAMPELLO","22N ALICANTE- PLAYA SAN JUAN","23N ALICANTE- MUTXAMEL","24N ALICANTE-UNIVERSIDAD-S.VICENTE","25N PLAZA ESPAÑA - VILLAFRANQUEZA","01 S. GABRIEL-JUAN XXIII  (1ºS)","02 LA FLORIDA-SAGRADA FAMILIA","03 CIUDAD DE ASIS-COLONIA REQUENA","04 CEMENTERIO-TOMBOLA","05 EXPLANADA-SAN BLAS-RABASA","06 E.AUTOBUSES - COLONIA REQUENA","07 AV.ÓSCAR ESPLÁ-REBOLLEDO","8A VIRGEN DEL REMEDIO-EXPLANADA","09 AV.OSCAR ESPLA - AV. NACIONES","10 EXPLANADA-C.C. VISTAHERMOSA","11 PZ.LUCEROS-AV. DENIA-H.ST.JOAN","11H PZ.LUCEROS-H.ST JOAN","12 AV. CONSTITUCION-S. BLAS(PAUI)","16 PZA. ESPAÑA-MERCADILLO TEULADA","17 ZONA NORTE-MERCADILLO TEULADA","8B EXPLANADA-VIRGEN DEL REMEDIO","191 PLA - CAROLINAS - RICO PEREZ","192 C. ASIS - BENALUA - RICO PEREZ","M MUTXAMEL-URBANITZACIONS","CEM MUTXAMEL - CEMENTERIO","C2 VENTA LANUZA - EL CAMPELLO","C-51 MUTXAMEL - BUSOT","C-52 BUSOT - EL CAMPELLO","C-53 HOSPITAL SANT JOAN - EL CAMPELLO","C-54 UNIVERSIDAD-HOSP. SANT JOAN","C6 ALICANTE-AEROPUERTO","45 HOSPITAL-GIRASOLES-MANCHEGOS","46A HOSPITAL-VILLAMONTES-S.ANTONIO","46B HOSPITAL-P.CANASTELL-P.COTXETA","TURI BUS TURÍSTICO (TURIBUS)","31 MUTXAMEL-ST.JOAN-PLAYA S. JUAN","30P SAN VICENTE-PLAYA SAN JUAN","C6* ALICANTE-URBANOVA-AEROPUERTO"];
    property variant lineasCodigoKml: ["ALC21","ALC22","ALC23","ALC24","ALC25","ALC26","ALC27","ALC30","ALCC55","ALC34","ALC35","ALC36","ALC37","ALC38","ALC39","ALC21N","ALC22N","ALC23N","ALC24N","ALC25N","MAS01","MAS02","MAS03","MAS04","MAS05","MAS06","MAS07","MAS8A","MAS09","MAS10","MAS11","MAS11H","MAS12","MAS16","MAS17","MAS8B","MAS191","MAS192","MUTM","MUT136","CAMPC2","ALCC51","ALCC52","ALCC53","ALCC54","ALCC6","ALCS45","ALCS46A","ALCS46B","Turibus","ALC31","ALC30B","ALCC6"];
    property variant lineasNum: ["21","22","23","24","25","26","27","30","C-55","34","35","36","37","38","39","21N","22N","23N","24N","25N","01","02","03","04","05","06","07","8A","09","10","11","11H","12","16","17","8B","191","192","M","CEM","C2","C-51","C-52","C-53","C-54","C6","45","46A","46B","TURI","31","30P","C6*"];



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






}
