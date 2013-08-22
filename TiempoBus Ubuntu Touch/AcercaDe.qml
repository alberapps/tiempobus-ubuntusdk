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
    anchors.top: texto3.bottom
    anchors.horizontalCenter: texto3.horizontalCenter
    label: "http://alberapps.blogspot.com"
    url: "http://alberapps.blogspot.com"
}

}
