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
import Ubuntu.Components.Popups 1.0
import QtQuick.LocalStorage 2.0

Tab {
    id: tabFavoritos
    title: i18n.tr("Favorites")
    onVisibleChanged: {

        if (tabFavoritos.visible) {
            cargarFavoritos()
        }
    }

    //Listado de favoritos
    page: Page {

        id: paginaFavoritos

        //Component.onCompleted: cargarFavoritos();
        /*Column {

            spacing: units.gu(1)
            anchors {
                margins: units.gu(1)
                fill: parent
            }
*/
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
                                PopupUtils.close(dialogue)

                                var favoritoParada = favoritosList.get(
                                            favoritoIndex).parada
                                paradaActual = favoritoParada

                                //entradaParada.text = paradaActual;
                                //paradaSeleccionada();
                                controlCambioParada = true

                                //Tab principal
                                tabs.selectedTabIndex = 0
                            }
                        }
                        Action {
                            text: i18n.tr("Modify")
                            onTriggered: {

                                PopupUtils.close(dialogue)


                                //formGuardar.cargarDatosModificar(favoritosList.get(favoritoIndex).titulo, favoritosList.get(favoritoIndex).descripcion);

                                //inputTitulo.text = favoritosList.get(favoritoIndex).titulo;
                                //inputDescripcion.text = favoritosList.get(favoritoIndex).descripcion;
                                modificarFavorito = favoritosList.get(
                                            favoritoIndex).rowid
                                paradaModificar = favoritosList.get(
                                            favoritoIndex).parada

                                pageStack.push(formGuardar)

                                //Devuelve a la lista
                                favoritosList.append({
                                                         parada: favoritosList.get(
                                                                     favoritoIndex).parada,
                                                         titulo: favoritosList.get(
                                                                     favoritoIndex).titulo,
                                                         descripcion: favoritosList.get(
                                                                          favoritoIndex).descripcion,
                                                         rowid: favoritosList.get(
                                                                    favoritoIndex).rowid
                                                     })
                            }
                        }
                        Action {
                            text: i18n.tr("Delete")
                            onTriggered: {
                                PopupUtils.close(dialogue)

                                var favoritoId = favoritosList.get(
                                            favoritoIndex).rowid

                                borrarFavorito(favoritoId)

                                cargarFavoritos()
                            }
                        }
                    }
                }
            }

            //Listado de favoritos
            UbuntuListView {
                id: listadoFavoritos
                //width: parent.width
                //height: parent.height - units.gu(10)
                anchors.fill: parent
                anchors.margins: units.gu(1)
                model: favoritosList

                clip: true

                delegate: ListItem.Subtitled {
                    id: item1
                    text: parada + " - " + titulo
                    subText: descripcion

                    onClicked: {

                        favoritoIndex = index

                        PopupUtils.open(dialogFavorito, null)
                    }
                }
            }


            Scrollbar {
                flickableItem: listadoFavoritos
            }

        }
    //}

    //Cargar la lista de favoritos
    function cargarFavoritos() {

        favoritosList.clear()

        var db = LocalStorage.openDatabaseSync("TiempoBusFavoritosDB", "1.0",
                                               "Base de datos de favoritos",
                                               1000000)

        db.transaction(function (tx) {

            // Show all added greetings
            var rs = tx.executeSql('SELECT ROWID,* FROM Favoritos')

            var r = ""
            for (var i = 0; i < rs.rows.length; i++) {

                favoritosList.append({
                                         parada: rs.rows.item(i).parada,
                                         titulo: rs.rows.item(i).titulo,
                                         descripcion: rs.rows.item(
                                                          i).descripcion,
                                         rowid: rs.rows.item(i).rowid
                                     })

                //console.log(rs.rows.item(i).rowid);
            }
        })

        if (favoritosList.count < 1) {
            listadoVacioFavoritos.visible = true
        } else {
            listadoVacioFavoritos.visible = false
        }
    }

    //Borrar favorito de la base de datos
    function borrarFavorito(favoritoId) {

        var db = LocalStorage.openDatabaseSync("TiempoBusFavoritosDB", "1.0",
                                               "Base de datos de favoritos",
                                               1000000)

        db.transaction(function (tx) {

            // Show all added greetings
            tx.executeSql('DELETE FROM Favoritos WHERE ROWID=' + favoritoId)
        })

        if (favoritosList.count < 1) {
            listadoVacioFavoritos.visible = true
        } else {
            listadoVacioFavoritos.visible = false
        }
    }
}
