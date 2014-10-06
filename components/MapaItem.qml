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
import Ubuntu.Components.Popups 0.1

Location.MapQuickItem {
    //id: item
    anchorPoint.x: itemImage.width * 0.5
    anchorPoint.y: itemImage.height
    z: 8

    property string titulo: ''
    property string descripcion: ''
    property string sentido: 'ida'
    property string parada: '2902'

    sourceItem: Image {
        id: itemImage

        source: {
            if (sentido === 'ida') {
                Qt.resolvedUrl("../graphics/busstop_blue.png")
            } else {
                Qt.resolvedUrl("../graphics/busstop_green.png")
            }
        }
    }

    Location.MapMouseArea {
        anchors.fill: parent
        onClicked: {
            PopupUtils.open(dialog, null)
        }
    }

    Component {
        id: dialog

        Dialog {
            id: dialogue

            title: titulo
            text: descripcion

            Button {
                text: i18n.tr("Cancel")
                gradient: UbuntuColors.greyGradient
                onClicked: PopupUtils.close(dialogue)
            }
            Button {
                text: i18n.tr("Load")
                onClicked: {
                    PopupUtils.close(dialogue)

                    paradaActual = parada

                    controlCambioParada = true

                    //Tab principal
                    tabs.selectedTabIndex = 0
                }
            }
        }
    }
}
