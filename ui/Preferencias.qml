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
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Components 1.1 as Toolkit
import "../components"

Page {
    title: i18n.tr("Settings")

    Component.onCompleted: {
        cargarPreferencias()

        if (preferencias.cargaAutomatica === "true") {
            console.debug('SI')
            confCargaAuto.checked = true
        } else {
            console.debug('NO: ' + preferencias.cargaAutomatica)
            confCargaAuto.checked = false
        }
    }

    Flickable {


        //anchors.top: texto5.bottom
        id: flick

        flickableDirection: Flickable.VerticalFlick
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: units.gu(100)


        Column {
            id: columnaPref
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: units.gu(1)

        ListItem.Standard {
            id: listadoPreferencias
            text: i18n.tr("Automatic Refresh")
            control: Toolkit.Switch {
                id: confCargaAuto
                anchors.verticalCenter: parent.verticalCenter

                onClicked: {
                    console.log('PREFERENCIAS CAMBIADA: ' + confCargaAuto.checked)

                    var temp = preferencias

                    if (confCargaAuto.checked) {
                        temp.cargaAutomatica = 'true'
                        console.log('OK')
                    } else {
                        temp.cargaAutomatica = 'false'
                        console.log('NOOK')
                    }

                    preferencias = temp

                    guardarPreferencias()
                }
            }
        }

        ListItem.Standard {
            id: listadoPreferencias2
            text: i18n.tr("Delete DataBase")
            control: Button {
                id: boton1
                text: i18n.tr("Delete")

                onClicked: {
                    borrarDB();
                }
            }
        }

        }

        Column {
            id: listadoLabel
            anchors.top: columnaPref.bottom
            spacing: units.gu(0.5)
            anchors.horizontalCenter: parent.horizontalCenter

            anchors.topMargin: units.gu(3)

            Image {
                id: imagen
                anchors.horizontalCenter: parent.horizontalCenter


                source: Qt.resolvedUrl("../graphics/tiempobus.png")
                width: units.gu(10)
                height: units.gu(10)
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "TiempoBus 0.8 BETA"
                fontSize: "x-large"
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Alberto Montiel 2015"
                fontSize: "large"
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: i18n.tr("This is a BETA version.")
                fontSize: "medium"
            }

            WebLink {
                anchors.horizontalCenter: parent.horizontalCenter
                id: texto4
                label: "alberapps.blogspot.com"
                url: "http://alberapps.blogspot.com"
            }

            WebLink {
                anchors.horizontalCenter: parent.horizontalCenter
                id: textoEmail
                label: "alberapps@gmail.com"
                url: "mailto:alberapps@gmail.com"
            }

            WebLink {
                anchors.horizontalCenter: parent.horizontalCenter
                id: textoTW
                label: "@alberapps"
                url: "http://twitter.com/alberapps"
            }

            WebLink {
                anchors.horizontalCenter: parent.horizontalCenter
                id: texto5
                label: i18n.tr("License GPLv3")
                url: "http://www.gnu.org/licenses/gpl.html"
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "\n" + i18n.tr("This application is UNofficial and its development is independent.\nLines and times data offered and maintained by:")
                fontSize: "x-small"
            }
            WebLink {
                anchors.horizontalCenter: parent.horizontalCenter
                id: textoSubus
                label: 'subus.es'
                url: "http://www.subus.es"
            }




            Label {

                anchors.horizontalCenter: parent.horizontalCenter
                text: "\n\n" + i18n.tr(
                          "TiempoBus - Informacion sobre tiempos de paso de autobuses en Alicante\nCopyright (C) 2015 Alberto Montiel\n\nThis program is free software: you can redistribute it and/or modify\nit under the terms of the GNU General Public License as published by\nthe Free Software Foundation, either version 3 of the License, or\n(at your option) any later version.\n\nThis program is distributed in the hope that it will be useful,\nbut WITHOUT ANY WARRANTY; without even the implied warranty of\nMERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\nGNU General Public License for more details.\n\nYou should have received a copy of the GNU General Public License\nalong with this program.  If not, see <http://www.gnu.org/licenses/>.")
                fontSize: "x-small"
                //wrapMode: Label.Wrap
                //width: parent.width - units.gu(20)
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: i18n.tr("Logo de la App compuesto con http://www.elegantthemes.com/blog/\nfreebie-of-the-week/flat-icon-collection-update\n(http://www.gnu.org/licenses/gpl-2.0.html")
                fontSize: "x-small"
            }



        }
    }






    /** FUNCIONES BASE DE DATOS LINEAS
      */
    //Cargar datos de la parada
    function borrarDB(){

        var db = LocalStorage.openDatabaseSync("TiempoBusInfoLineasDB", "1.0", "Base de datos de favoritos", 1000000);

        var datosParada;

        db.transaction(
                    function(tx) {

                        console.info("Inicio borrado de tabla");

                        try{
                            var rs3 = tx.executeSql('DELETE FROM LINEAS');

                            console.info("Tabla borrada");


                        }catch(e){

                            console.error(e);

                        }




                    }
                    )




    }
















}
