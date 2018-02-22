import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Dialog {
    id: aboutProductDialogue
    title: i18n.tr("Información del producto")
    text: "Weather Recorder: versión " + root.appVersion + "<br/> La temperatura en tu ciudad favorita"

    Button {
        text: "Cerrar"
        onClicked: PopupUtils.close(aboutProductDialogue)
    }
}
