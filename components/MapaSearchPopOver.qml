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
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import QtQuick.XmlListModel 2.0
import QtPositioning 5.2

Component
{
    Popover
    {
        id: searchPopover
        Column
        {
            anchors
            {
                left: parent.left
                top: parent.top
                right: parent.right
                margins: units.gu(1)
            }
            spacing: units.gu(1)
            ListItem.SingleControl
            {
                control: Icon
                {
                    name: "search"
                    color: UbuntuColors.midAubergine
                    height: units.gu(5)
                    width: units.gu(5)
                }
            }
            /*TextField
            {
                id: addressField
                width: parent.width
                placeholderText: "Address"
            }*/

           /* OptionSelector
            {
                height:units.gu(25)
                 anchors.fill: parent

                id: citySelector
                text: "City"
                model: lineasMapaList
                    //["Washington, DC", "Arlington, VA", "Alexandria, VA", "Bethesda, MD", "Fairfax, VA", "Falls Church, VA", "Reston, VA", "Rockville, MD", "Silver Spring, MD"]



                delegate: OptionSelectorDelegate{
                    //text: linea
                    subText: descripcion

                    /*onClicked: {
                        console.debug('tiempo seleccionado');
                    }*/
                //}

              //  Component.onCompleted: {
                //    cargarLineas();
                //}

           // }*/
            /*Button
            {
                text: "search"
                onClicked:
                {
                    /*var url = "http://nominatim.openstreetmap.org/search/{{address}},%20{{city}}?format=xml"
                    url = url.replace("{{address}}", addressField.text)
                    url = url.replace("{{city}}", citySelector.model[citySelector.selectedIndex])
                    resultsModel.source = url
                    resultsModel.reload()*/
              //  }
            //}

            UbuntuListView
            {
                height:units.gu(25) - 5
                width: parent.width
                //clip: true
                id: resultsList
                model: lineasMapaList

                delegate: ListItem.Standard
                {
                    text: descripcion
                    height: units.gu(5)
                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked:
                        {
                            //getThereMap.navigateToFoundLocation(lat, lon)

                            tabMapa.cargarParadas(linea);

                            PopupUtils.close(searchPopover)
                        }
                    }
                }

            Component.onCompleted: {
                                cargarLineas();
                            }
            }



            ListItem.SingleControl
            {
                control: Button
                {
                    text: "Close"
                    onClicked:
                    {
                        PopupUtils.close(searchPopover)
                    }
                }
            }
        }

        ActivityIndicator
        {
            anchors.centerIn: parent
            visible: resultsModel.status == XmlListModel.Loading
            running: true
        }

        XmlListModel
        {
            id: resultsModel
            query: "/searchresults/place"

            XmlRole { name: "lat"; query: "@lat/string()";}
            XmlRole { name: "lon"; query: "@lon/string()";}
            XmlRole { name: "displayName"; query: "@display_name/string()";}
            onStatusChanged:
            {
                if(status == XmlListModel.Null)
                {
                    //print("No xml data set")
                }
                if(status == XmlListModel.Ready)
                {
                    //print(count + " results loaded from xml")
                }
                if(status == XmlListModel.Loading)
                {
                    //print(resultsModel.source)
                    //print("Loading results data")
                }
                if(status == XmlListModel.Error)
                {
                    //print("ERROR: " + errorString())
                }
            }
        }


        //Modelo para listado de lineas
        ListModel {
            id: lineasMapaList
            ListElement {
                linea: "-1"
                descripcion: ""
                operacion: ""

            }

        }






    //Carga la lista de lineas
   function cargarLineas(){

        lineasMapaList.clear();

        for(var i = 0;i<datosConstantes.lineasNum.length;i++){

            lineasMapaList.append({"linea": datosConstantes.lineasNum[i], "descripcion": datosConstantes.lineasDescripcion[i]});

        }


    }



    }







}
