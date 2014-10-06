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
import "ui"
import "components"

/*!
    \brief MainView with Tabs element.
           First Tab has a single Label and
           second Tab has a single ToolbarAction.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.ubuntu.developer.alberapps.tiempobus"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    // Removes the old toolbar and enables new features of the new header.
    useDeprecatedToolbar: false

    width: units.gu(50)
    height: units.gu(75)

    // Variables globales
    property string paradaActual: '4450';
    property string modificarFavorito: '';
    property string paradaModificar: '';

    property string favoritoIndex: '';
    property string lineaIndex: '';
    property string paradaIndex: '';

    property bool controlCambioParada: false;

    property variant preferencias:{'paradaInicial':'4450', 'cargaAutomatica': 'false'};


    PageStack {
        id: pageStack

        Component.onCompleted: {
            //Para desktop Quitar para crear click
            //i18n.domain = 'tiempobus'
            //i18n.bindtextdomain("tiempobus","/usr/share/locale")
            //Fin para desktop
            push(tabs)
        }



        Errores{
             objectName: "errores"
              id: cErrores
         }

        Datos {
            id: datosConstantes
        }

        Tabs {
            id: tabs

            Tiempos {
                objectName: "tiempos"
            }

            Favoritos {
                objectName: "favoritos"
            }

            Buscador {
                objectName: "buscador"
                id:idBuscar
            }

            Mapas {
                objectName: "mapas"
            }

            Noticias {
                objectName: "noticias"
            }

        }


        NuevoFavorito{
            id: formGuardar
            objectName: "nuevoFavorito"
            visible: false
        }


        Preferencias{
            id: formPreferencias
            objectName: "preferencias"
            visible: false
        }

    }


    //Barra de progreso
    ProgressBar {
        id: indeterminateBar
        indeterminate: true
        visible: false
        anchors.centerIn: parent
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
