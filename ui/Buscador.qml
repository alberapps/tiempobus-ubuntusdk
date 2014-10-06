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
import Ubuntu.Components.Popups 1.0

Tab {
    title: i18n.tr("Search")
    page: Page {

        id: buscador

        Component.onCompleted: cargarLineas()

        Column {

            spacing: units.gu(1)
            anchors {
                margins: units.gu(2)
                fill: parent
            }

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
                            PopupUtils.close(dialogue)

                            cargarParadas(lineasList.get(paradaIndex).linea,
                                          "ida")

                            headerParadas.text = i18n.tr("Forward")

                            pageStack.push(buscadorParadasIda)
                        }
                    }
                    Button {
                        text: "Vuelta"
                        onClicked: {

                            PopupUtils.close(dialogue)

                            cargarParadas(lineasList.get(paradaIndex).linea,
                                          "vuelta")

                            headerParadas.text = i18n.tr("Backward")

                            pageStack.push(buscadorParadasIda)
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

                    onClicked: {

                        var favoritoParada = paradasList.get(paradaIndex).parada

                        paradaActual = favoritoParada
                        //entradaParada.text = paradaActual;
                        //paradaSeleccionada();
                        controlCambioParada = true

                        //Tab principal
                        tabs.selectedTabIndex = 0
                    }
                }
            }

            ListItem.ItemSelector {
                model: lineasList
                id: itemLineas
                //text: i18n.tr("Lineas")
                delegate: selectorDelegate

                onDelegateClicked: {


                    //itemSentido.selectedIndex = 1;
                    lineaIndex = index

                    if (lineaIndex === 0) {


                        //No seleccionado
                    } else if (itemSentido.selectedIndex === 0) {

                        cargarParadas(lineasList.get(lineaIndex).linea, "ida")
                    } else {

                        cargarParadas(lineasList.get(lineaIndex).linea,
                                      "vuelta")
                    }
                }
            }

            Component {
                id: selectorDelegate
                Toolkit.OptionSelectorDelegate {
                    text: {
                        if (linea != "-1") {
                            linea
                        } else {
                            i18n.tr("Select Bus Line")
                        }
                    }
                    subText: {
                        if (linea != "-1") {
                            descripcion
                        } else {
                            ''
                        }
                    }
                }
            }

            OptionSelector {
                id: itemSentido

                //objectName: "sentido"
                //text: i18n.tr("Sentido")
                model: [i18n.tr("Forward"), i18n.tr("Backward")]

                onDelegateClicked: {
                    if (lineaIndex !== 0) {
                        if (index === 0) {
                            cargarParadas(lineasList.get(lineaIndex).linea,
                                          "ida")
                        } else {
                            cargarParadas(lineasList.get(lineaIndex).linea,
                                          "vuelta")
                        }
                    }
                }
            }

            ListItem.ItemSelector {
                model: paradasList
                id: itemParadas
                //text: i18n.tr("Paradas")
                delegate: selectorDelegateParada

                onDelegateClicked: {

                    if (paradasList.get(index).parada !== '-1') {
                        paradaIndex = index

                        botonCargarFav.enabled = true
                        botonCargarFav.color = UbuntuColors.orange
                    } else {
                        botonCargarFav.enabled = false
                        botonCargarFav.color = UbuntuColors.warmGrey
                    }
                }
            }

            Component {
                id: selectorDelegateParada
                Toolkit.OptionSelectorDelegate {
                    text: {
                        if (parada != '-' && parada != -1) {
                            parada + " - " + direccion
                        } else {
                            i18n.tr("Select Bus Stop")
                        }
                    }
                    subText: {
                        if (parada != '-' && parada != -1) {
                            " T: " + lineas
                        } else {
                            ""
                        }
                    }
                }
            }
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

    //Carga la lista de lineas
    function cargarLineas() {

        lineasList.clear()

        //default
        lineasList.append({
                              linea: "-1",
                              descripcion: i18n.tr("Select Bus Line")
                          })
        //Opcion por defecto
        paradasList.append({
                               parada: "-1",
                               descripcion: i18n.tr("Select Bus Stop"),
                               lineas: "-",
                               sentido: "-",
                               direccion: i18n.tr("Select Bus Stop")
                           })

        for (var i = 0; i < datosConstantes.lineasNum.length; i++) {

            lineasList.append({
                                  linea: datosConstantes.lineasNum[i],
                                  descripcion: datosConstantes.lineasDescripcion[i]
                              })
        }
    }

    //Cargar la lista de paradas del sentido indicado
    function cargarParadas(linea, sentido) {

        indeterminateBar.visible = true

        paradasList.clear()

        //Opcion por defecto
        paradasList.append({
                               parada: "-1",
                               descripcion: i18n.tr("Select Bus Stop"),
                               lineas: "-",
                               sentido: "-",
                               direccion: i18n.tr("Select Bus Stop")
                           })

        var url = generarUrlLineaNuevo(linea)

        var doc = new XMLHttpRequest()

        doc.open("GET", url, true)

        doc.onreadystatechange = function () {

            try {

                if (doc.readyState === XMLHttpRequest.HEADERS_RECEIVED) {

                } else if (doc.readyState === XMLHttpRequest.DONE) {


                    // showRequestInfo("salida: " + doc.responseText);
                    //console.debug(doc.responseText);
                    var a = doc.responseXML.documentElement

                    //var folderPrincipalList = a.getElementsByTagName('Folder');
                    var folderPrincipalList = getElementsByTagName(a, 'Folder')

                    var direccionalidad = folderPrincipalList[1].childNodes[1].childNodes[0].nodeValue

                    console.debug(
                                "DIRECCIONALIDAD: "
                                + folderPrincipalList[1].childNodes[1].childNodes[0].nodeValue)

                    var folderIda
                    var folderVuelta

                    if (direccionalidad === 'Ida') {
                        folderIda = folderPrincipalList[1]
                        folderVuelta = folderPrincipalList[2]
                    } else {
                        folderIda = folderPrincipalList[2]
                        folderVuelta = folderPrincipalList[1]
                    }

                    var items

                    if (sentido === 'ida') {
                        //items = folderIda.getElementsByTagName('Placemark');
                        items = getElementsByTagName(folderIda, 'Placemark')
                    } else {
                        //items = folderVuelta.getElementsByTagName('Placemark');
                        items = getElementsByTagName(folderVuelta, 'Placemark')
                    }

                    var item
                    var datosPlaceMark
                    var dato
                    var etiqueta
                    var descripcion

                    for (var ii = 0; ii < items.length; ++ii) {

                        item = items[ii]
                        datosPlaceMark = item.childNodes

                        for (var j = 0; j < datosPlaceMark.length; ++j) {

                            dato = datosPlaceMark[j]
                            etiqueta = dato.nodeName

                            //console.log("etiqueta: " + etiqueta);
                            if (etiqueta === "name") {
                                var direccion = dato.childNodes[0].nodeValue
                            }

                            if (etiqueta === 'description') {

                                descripcion = dato.childNodes[0].nodeValue

                                //console.log("valor: " + descripcion);
                                var procesaDesc = descripcion.split(" ")

                                var parada = procesaDesc[3].trim()

                                // posicion sentido
                                var sent = descripcion.indexOf("Sentido")
                                var neas = descripcion.indexOf("neas")

                                // lineas conexion
                                var lineas = descripcion.substring(neas + 5,
                                                                   sent).trim()

                                // Sentido
                                var sentidoRecorrido = descripcion.substring(
                                            sent + 8).trim()

                                console.debug(
                                            "parada: " + parada + "lineas: " + lineas
                                            + "sentido: " + sentidoRecorrido)

                                paradasList.append({
                                                       parada: parada,
                                                       descripcion: descripcion,
                                                       lineas: lineas,
                                                       sentido: sentidoRecorrido,
                                                       direccion: direccion
                                                   })
                            }
                        }
                    }
                }
            } catch (error) {

                cErrores.manejarError('1')
            }

            indeterminateBar.visible = false
        }

        doc.setRequestHeader('Content-Type', 'text/xml; charset=utf-8')

        doc.send()
    }

    //Url de consulta de la linea. Indicar el sentido de ida o vuelta
    function generarUrlLinea(linea, sentido) {

        var url = "http://www.subus.es/Lineas/kml/"

        var urlSufijoIda = ""

        if (sentido === "ida") {
            urlSufijoIda = "ParadasIda.xml"
        } else {
            urlSufijoIda = "ParadasVuelta.xml"
        }

        var indiceLinea = datosConstantes.lineasNum.indexOf(linea)

        var urlIda = url + datosConstantes.lineasCodigoKml[indiceLinea] + urlSufijoIda

        console.debug("urlIda: " + urlIda)

        return urlIda
    }

    function generarUrlLineaNuevo(linea) {

        var url = "http://www.subus.es/K/"

        var urlSufijo = ""

        urlSufijo = "P.xml"

        var indiceLinea = datosConstantes.lineasNum.indexOf(linea)

        var urlCompleta = url + datosConstantes.lineasCodigoKml[indiceLinea] + urlSufijo

        console.debug("urlIda: " + urlCompleta)

        return urlCompleta
    }

    function getElementsByTagName(rootElement, tagName) {

        var childNodes = rootElement.childNodes
        var elements = []
        for (var i = 0; i < childNodes.length; i++) {


            //console.debug('nodo: ' + childNodes[i].nodeName);
            if (childNodes[i].nodeName === tagName) {
                elements.push(childNodes[i])
            }

            if (childNodes[i].childNodes.length > 0) {

                elements = elements.concat(getElementsByTagName(childNodes[i],
                                                                tagName))
            }
        }

        return elements
    }
}
