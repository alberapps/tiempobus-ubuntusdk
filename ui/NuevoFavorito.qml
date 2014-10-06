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
import QtQuick.LocalStorage 2.0
import "../components"


//Pagina de nuevo favorito
Page {
    title: i18n.tr("Save")

    onVisibleChanged: {
        cargarDatosModificar()
    }

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
                textFormat: TextEdit.RichText
                //text: longText
            }
        }

        TemplateRow {

            height: botonGuardar.height

            Button {
                id: botonGuardar
                text: i18n.tr("Save")
                width: units.gu(12)
                onClicked: {
                    guardarFavorito(inputTitulo.text,
                                    inputDescripcion.displayText)
                    inputTitulo.text = ''
                    inputDescripcion.text = ''
                    favoritoIndex = ''
                    pageStack.pop()
                }
            }
        }
    }

    //Guardar favorito en la base de datos
    function guardarFavorito(titulo, descrip) {


        //.local/share/Qt Project/QtQmlViewer/QML/OfflineStorage/Databases
        var db = LocalStorage.openDatabaseSync("TiempoBusFavoritosDB", "1.0",
                                               "Base de datos de favoritos",
                                               1000000)

        db.transaction(function (tx) {
            // Create the database if it doesn't already exist
            tx.executeSql(
                        'CREATE TABLE IF NOT EXISTS Favoritos(parada TEXT, titulo TEXT, descripcion TEXT)')

            //Modificar o crear nuevo
            if (modificarFavorito === '') {

                // Add (another) greeting row
                tx.executeSql('INSERT INTO Favoritos VALUES(?, ?, ?)',
                              [paradaActual, titulo, descrip])
            } else if (modificarFavorito !== '') {

                tx.executeSql(
                            'UPDATE Favoritos SET parada = ?, titulo = ?, descripcion = ? WHERE rowid = ?',
                            [paradaModificar, titulo, descrip, modificarFavorito])

                modificarFavorito = ''

                //cargarFavoritos();
            }
        })
    }

    /*
         * Cargar datos si se trata de una modificacion
             */
    function cargarDatosModificar() {

        if (favoritoIndex != null && favoritoIndex != '') {

            inputTitulo.text = favoritosList.get(favoritoIndex).titulo
            inputDescripcion.text = favoritosList.get(favoritoIndex).descripcion
        } else {
            inputTitulo.text = ''
            inputDescripcion.text = ''
        }
    }
}
