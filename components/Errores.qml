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
import Ubuntu.Components.Popups 1.0

Rectangle {
    width: 0
    height: 0

    property string descripcion: ''

    property string error_1: i18n.tr("Data Error")
    property string error_2: i18n.tr("Generic Error")

    Component {
        id: dialogoErrores

        Dialog {
            id: dialogoErrores2

            title: 'ERROR'
            text: descripcion

            Button {
                text: i18n.tr("Ok")
                onClicked: PopupUtils.close(dialogoErrores2)
            }
        }
    }

    function manejarError(error) {

        if (error === '1') {

            descripcion = error_1
        } else {

            descripcion = error_2
        }

        PopupUtils.open(dialogoErrores, null)
    }
}
