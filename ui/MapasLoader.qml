import QtQuick 2.2
import Ubuntu.Components 1.1


Tab {
    id:tabMapa
    title: i18n.tr("Maps")
    onVisibleChanged: {

        if(tabMapa.visible){
            PopupUtils.open(searchPopoverComponent);
        }
    }

    page: Page {

        id: paginaMapas

    }

}
