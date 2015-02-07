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
import Ubuntu.Components.ListItems 1.0
import Ubuntu.Components.Popups 1.0
import QtQuick.XmlListModel 2.0
import "../components"

Tab {
    id: tabNoticias
    title: i18n.tr("Notices and News")
    onVisibleChanged: {

    }
    page: Page {

        id: paginaMapas

        UbuntuListView {

            id: listView

            anchors.fill: parent
            anchors.margins: units.gu(1)
            clip: true


            //property alias status: rssModel.status
            model: XmlListModel {
                id: rssModel
                source: "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20html%20where%20url%3D%22http%3A%2F%2Fsubus.es%2FEspeciales%2FNovedades%2FNovedades.asp%22%20and%0A%20%20%20%20%20%20charset%3D'windows-1252'%20and%20xpath%3D'%2F%2Ftr%5Bcontains(%40class%2C%22impar%22)%5D'%20"
                query: "/query/results/tr"

                XmlRole {
                    name: "published"
                    query: "normalize-space(td[1]/string())"
                }

                XmlRole {
                    name: "title"
                    query: "normalize-space(td[2]/string())"
                }

                /*XmlRole { name: "title"; query: "title/string()" }
                               XmlRole { name: "published"; query: "pubDate/string()" }
                                              XmlRole { name: "content"; query: "*[name()='content:encoded']/string()" }*/
            }

            pullToRefresh {
                //enable: true
                refreshing: rssModel.status === XmlListModel.Loading
                onRefresh: {
                    console.log('recargando')
                    rssModel.reload()
                }
            }


            //model: rssModel
            //td[contains(@style,\"text-align:center\")]

            // let refresh control know when the refresh gets completed
            delegate: Subtitled {
                text: published
                subText: title
                progression: true

                onClicked: {
                    Qt.openUrlExternally(
                                "http://www.subus.es/Especiales/Novedades/Novedades.asp")
                }
            }

            Scrollbar {
                flickableItem: listView
            }


        }

        tools: ToolbarItems {

            ToolbarButton {
                action: Action {
                    id: reloadAction
                    text: "Reload"
                    iconName: "reload"
                    onTriggered: {
                        console.log('recargando')
                        rssModel.reload()
                    }
                }
            }
        }
    }
}
