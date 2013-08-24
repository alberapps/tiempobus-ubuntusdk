import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1

Rectangle {
    color: Theme.palette.normal.background
    width: units.gu(80)
    height: units.gu(80)
    Component {
        id: popoverComponent

        Popover {
            id: popover
            Column {
                id: containerLayout
                anchors {
                    left: parent.left
                    top: parent.top
                    right: parent.right
                }
                ListItem.Header { text: "Standard list items" }
                ListItem.Standard { text: "Do something" }
                ListItem.Standard { text: "Do something else" }
                ListItem.Header { text: "Buttons" }
                ListItem.SingleControl {
                    highlightWhenPressed: false
                    control: Button {
                        text: "Do nothing"
                        anchors {
                            fill: parent
                            margins: units.gu(1)
                        }
                    }
                }
                ListItem.SingleControl {
                    highlightWhenPressed: false
                    control: Button {
                        text: "Close"
                        anchors {
                            fill: parent
                            margins: units.gu(1)
                        }
                        onClicked: PopupUtils.close(popover)
                    }
                }
            }
        }
    }
    Button {
        id: popoverButton
        anchors.centerIn: parent
        text: "open"
        onClicked: PopupUtils.open(popoverComponent, popoverButton)
    }
}
