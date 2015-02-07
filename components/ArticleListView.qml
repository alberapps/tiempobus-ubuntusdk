import QtQuick 2.2
import QtQuick.XmlListModel 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0

UbuntuListView {
   id: listView
   //property alias status: rssModel.status

   /*model: XmlListModel {
       id: rssModel
       query: "/rss/channel/item"
       XmlRole { name: "title"; query: "title/string()" }
       XmlRole { name: "published"; query: "pubDate/string()" }
       XmlRole { name: "content"; query: "*[name()='content:encoded']/string()" }
   }*/

   model: rssModel


   delegate: Subtitled {
       text: title
       subText: published
       progression: true
   }


   Scrollbar {
       flickableItem: listView
   }


   //Modelo para listado de favoritos
   ListModel {
       id: rssModel
       ListElement {
           title: "prueba"
           published: ""
           content: ""

       }

   }

}
