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
import Ubuntu.Components.ListItems 1.0
import Ubuntu.Components.Popups 1.0

import "../components"



Tab {
    id:tabNoticias
    title: i18n.tr("News")
    onVisibleChanged: {

        if(tabNoticias.visible){
            cargarNoticias();
        }


    }
    page: Page {

        id: paginaMapas



        /*ArticleListView {
                       id: articleList
                       objectName: "articleList"
                       anchors.fill: parent
                       clip: true



                   }*/


        UbuntuListView {

           id: listView

           anchors.fill: parent
           anchors.margins: units.gu(1)
           clip: true

           //property alias status: rssModel.status

           /*model: XmlListModel {
               id: rssModel
               query: "/rss/channel/item"
               XmlRole { name: "title"; query: "title/string()" }
               XmlRole { name: "published"; query: "pubDate/string()" }
               XmlRole { name: "content"; query: "*[name()='content:encoded']/string()" }
           }*/

           model: rssModel


           delegate: Subtitled {
               text: published
               subText: title
               progression: true


               onClicked: {
                    Qt.openUrlExternally("http://www.subus.es/Especiales/Novedades/Novedades.asp");
               }

           }


           Scrollbar {
               flickableItem: listView
           }


           //Modelo para listado de favoritos
           ListModel {
               id: rssModel
               ListElement {
                   title: "prueba"
                   published: ""
                   content: ""

               }


           }

        }










        tools: ToolbarItems {

                    ToolbarButton {
                        action: Action {
                            id: reloadAction
                            text: "Reload"
                            iconName: "reload"
                            onTriggered: {cargarNoticias();}
                        }

                    }

                }





    }


    function cargarNoticias(){


         indeterminateBar.visible = true;


            var url = "http://www.subus.es/Especiales/Novedades/Novedades.asp";

            var doc = new XMLHttpRequest();

            doc.open("GET", url, true);


            doc.onreadystatechange = function(){

                try{


                if(doc.readyState === XMLHttpRequest.HEADERS_RECEIVED){


                }else if(doc.readyState === XMLHttpRequest.DONE){

                   // showRequestInfo("salida: " + doc.responseText);
                    console.debug(doc.responseText);

                    var texto = doc.responseText;

                    var lineas = texto.split('\n');

                    console.debug('lineas: ' + lineas.length);



                    for(var i=0;i<lineas.length;i++){

                        if(lineas[i].search('Fecha') !== -1){

                            //console.debug("linea encontrada: " + i);
                            //console.debug('contenido: ' + lineas[i]);

                            var datos = '';

                            for(var j= i+1; j< lineas.length; j++){

                                //var posicion = buscarFecha(lineas[j]);


                                var sinHTML = eliminarHtml(lineas[j]);

                                datos = datos + sinHTML;


                                //buscarFecha(sinHTML);

                                /*if(posicion !== -1){

                                    console.debug('posicion: ' + posicion);

                                    console.debug('Fecha: ' + lineas[j].substr(posicion, 10));

                                    //console.debug('Titulo: ' + lineas[j].substr(posicion + 30, 10));

                                    //Expresion regular de fecha

                                }*/


                            }


                            //Extraer datos
                            var listado = extraerDatos(datos);

                            cargarListadoNoticias(listado);


                             indeterminateBar.visible = false;




                            break;

                        }

                    }





                   //var a = doc.responseXML;//.documentElement;


                    //var tableList = idBuscar.getElementsByTagName(a, 'table');

                    //console.debug(a);

                    /*

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

                    //var items;


                    //if(sentido === 'ida'){
                        //items = folderIda.getElementsByTagName('Placemark');
                        var itemsIda = idBuscar.getElementsByTagName(folderIda, 'Placemark')
                    //}else{
                        //items = folderVuelta.getElementsByTagName('Placemark');
                        var itemsVuelta = idBuscar.getElementsByTagName(folderVuelta, 'Placemark')
                    //}



                    map.clearMapItems();

                    cargarParadasItems(itemsIda, 'ida', linea);

                    cargarParadasItems(itemsVuelta, 'vuelta', linea);

        */



                }



                }catch(error){

                    console.error(error);


                    cErrores.manejarError('1');


                }


            }


            //doc.setRequestHeader('Content-Type','text/html; charset=windows-1252');

        //ISO-8859-1

            doc.setRequestHeader('Content-Encoding', "UTF-8");




//Actualización de horarios de las líneas
            doc.send();

        }



        function buscarFecha(str){

            //04/10/2014

            var resultado;

            var regexp = /^[0-9]{2}\/[0-9]{2}\/[0-9]{4}$/

            //resultado = str.match(/(\d{1,2})\/(\d{1,2})\/(\d{4})/);

            resultado = str.match(regexp);


            return resultado;


            //console.debug('resultado: ' + resultado);


        }

        function eliminarHtml(str){

            var regexp = /(<([^>]+)>)/ig;
            //var regexp = "/<[^>]*>/ig";

            var result = str.replace(regexp, ";;");

            //console.debug('resultado2: ' + result);

            return result;


        }


        function extraerDatos(str){

            var sp = str.split(";;");

            var listadoNoticias = [];


            var contador = 0;

            for(var i =0; i< sp.length; i++){

                var registro = {};


                //console.debug(sp[i]);


                //Fecha, inicia registro
                if(buscarFecha(sp[i]) !== null){

                    registro.fecha = sp[i];
                    registro.titular = '';


                    for(var j =i+1; j< sp.length; j++){




                        if(buscarFecha(sp[j]) !== null){
                            break;
                        }

                        //sp[j].replace(/(?:\\[rn])+/g,' ');
                        var sinSaltos = sp[j].replace(/\r?\n|\r/,' ').replace(/&nbsp/g, '').replace(/;/g, '');



                        if(sinSaltos !== null && sinSaltos !== '' ){

                            var esc = cambiarCodificacion(sinSaltos);

                            registro.titular+=esc.trim();

                        }




                    }


                    listadoNoticias.push(registro);

                }




            }


            for(var i =0; i< listadoNoticias.length; i++){

                console.debug("fecha: " + listadoNoticias[i].fecha);
                console.debug("titular: " + listadoNoticias[i].titular);

            }


            return listadoNoticias;


        }


        function cargarListadoNoticias(listadoNoticias){

            rssModel.clear();



            for(var i = 0;i<listadoNoticias.length;i++){

                rssModel.append({"title": listadoNoticias[i].titular, "published": listadoNoticias[i].fecha});

            }




        }


        function cambiarCodificacion(str){

            //var esc = str.replace(/�/g,'ó').replace(/�/g,'á');

            //.replace(/�/,'í')

            //var esc = escape(str);

            var e = str.replace(/�/g, '');

            return e;

        }


}
