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
import QtLocation 5.0 as Location
import QtPositioning 5.2
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Components.Popups 1.0
import "../components"


Tab {
    id:tabMapa
    title: i18n.tr("Maps")
    onVisibleChanged: {

        if(tabMapa.visible){
            PopupUtils.open(searchPopoverComponent);
        }
    }

    page: Page {

        id: paginaMapas

            Location.Map {
                id: map
                anchors.fill: parent
                plugin: Location.Plugin { name: "osm" }
                center: QtPositioning.coordinate(38.3470003,-0.4873094)                
                zoomLevel: 14
                gesture.enabled: true
            }



            Location.MapQuickItem
            {
                id: item
                anchorPoint.x: itemImage.width * 0.5
                anchorPoint.y: itemImage.height
                z: 8

                sourceItem: Image
                {
                    id: itemImage
                    width: units.gu(5)
                    height: units.gu(5)
                    source: Qt.resolvedUrl("../graphics/busstop_blue.png")
                }


            }



            Column
            {

                anchors{
                    bottom: parent.bottom
                    right: parent.right
                    left: parent.left

                    bottomMargin: units.gu(1.5)
                    leftMargin: units.gu(1.5)
                }

                Row
                {
                    spacing: units.gu(2)
                    Column
                    {


                            UbuntuShape{
                                width: units.gu(5)
                                height: units.gu(5)
                                color: UbuntuColors.midAubergine

                                Label{
                                    anchors.centerIn: parent
                                    text: "+"
                                }
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: map.zoomLevel += 1
                                }
                            }

                            UbuntuShape{
                                width: units.gu(5)
                                height: units.gu(5)
                                color: UbuntuColors.midAubergine

                                Label{
                                    anchors.centerIn: parent
                                    text: "-"
                                }
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: map.zoomLevel += -1
                                }
                            }

                        }
                        Icon{
                            name: "search"
                            color: UbuntuColors.midAubergine
                            height: units.gu(5)
                            width: units.gu(5)
                            anchors{
                                bottom: parent.bottom
                            }

                            MouseArea{
                                anchors.fill: parent
                                onClicked: {



                                        PopupUtils.open(searchPopoverComponent);



                                }
                            }

                        }


                }

            }



    }


    MapaSearchPopOver
   {
       id: searchPopoverComponent
   }










//Cargar la lista de paradas del sentido indicado
function cargarParadas(linea){






     indeterminateBar.visible = true;





    var url = idBuscar.generarUrlLineaNuevo(linea);

    var doc = new XMLHttpRequest();

    doc.open("GET", url, true);


    doc.onreadystatechange = function(){

        try{


        if(doc.readyState === XMLHttpRequest.HEADERS_RECEIVED){



        }else if(doc.readyState === XMLHttpRequest.DONE){



            var a = doc.responseXML.documentElement;

            var folderPrincipalList = idBuscar.getElementsByTagName(a, 'Folder');

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


            var itemsIda = idBuscar.getElementsByTagName(folderIda, 'Placemark')
            var itemsVuelta = idBuscar.getElementsByTagName(folderVuelta, 'Placemark')




            cargarParadasItems(itemsIda, 'ida', linea);

            map.clearMapItems();

            cargarParadasItems(itemsIda, 'ida', linea);
            cargarParadasItems(itemsVuelta, 'vuelta', linea);

            indeterminateBar.visible = false;


        }



        }catch(error){


            cErrores.manejarError('1');

            indeterminateBar.visible = false;


        }


    }


    doc.setRequestHeader('Content-Type','text/xml; charset=utf-8');

    doc.send();

}




function cargarParadasItems(items, sentido, linea){


    var listado = [];

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







            }

            if(etiqueta === 'Point'){

                var coordenadas = dato.childNodes[1].childNodes[0].nodeValue;

                listado.push({"parada": parada, "descripcion": descripcion, "lineas": lineas, "sentido": sentidoRecorrido, "direccion": direccion, "coordenadas": coordenadas});


                var coord = coordenadas.split(',');

                var newCoord = QtPositioning.coordinate(coord[1], coord[0], 0)


                var nuevoMapaItem = Qt.createComponent('../components/MapaItem.qml');

                var nuevo = nuevoMapaItem.createObject();


                nuevo.coordinate = newCoord;

                nuevo.titulo = '[' + parada + '] ' + linea;

                nuevo.descripcion = 'Dirección: ' + direccion + '\n' + 'Destino: ' + sentidoRecorrido + '\nLineas:' + lineas;

                nuevo.sentido = sentido;

                nuevo.parada = parada;

                map.addMapItem(nuevo)





                console.debug("coord: " + coordenadas);

            }

        }


    }


    if(listado != null && listado.length > 0 && listado[0].coordenadas !== null){

        var coordCamara = listado[0].coordenadas.split(',');

        var newCoordCamara = QtPositioning.coordinate(coordCamara[1], coordCamara[0], 0)

        map.center = newCoordCamara;
    }



}




}
