/**
 *  TiempoBus - Informacion sobre tiempos de paso de autobuses en Alicante
 *  Copyright (C) 2013 Alberto Montiel
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
import "components"

Item{

Label {
    id: texto1
    anchors.centerIn: parent
    text: "TiempoBus 0.1"
    fontSize: "x-large"
}

Label {
    id:texto3
    anchors.top: texto1.bottom
    anchors.horizontalCenter: texto1.horizontalCenter

    text: "Alberto Montiel 2013"
    fontSize: "large"
}

/*
Label {
    id:texto4
    anchors.top: texto3.bottom
    anchors.horizontalCenter: texto3.horizontalCenter

    text: "http://alberapps.blogspot.com"
    fontSize: "medium"
}
*/
WebLink{
    id: texto4
    anchors.top: texto3.bottom
    anchors.horizontalCenter: texto3.horizontalCenter
    label: "http://alberapps.blogspot.com"
    url: "http://alberapps.blogspot.com"
}

WebLink{
    id: texto5
    anchors.top: texto4.bottom
    anchors.horizontalCenter: texto4.horizontalCenter
    label: "Licencia GPLv3"
    url: "http://www.gnu.org/licenses/gpl.html"
}


}
