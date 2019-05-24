import QtQuick 2.0

import "../components" as SuperiorComponents

TextEdit {
    color: SuperiorComponents.Style.defaultFontColor
    font.family: SuperiorComponents.Style.fontRegular.name
    selectionColor: SuperiorComponents.Style.dimmedFontColor
    wrapMode: Text.Wrap
    readOnly: true
    selectByMouse: true
    // Workaround for https://bugreports.qt.io/browse/QTBUG-50587
    onFocusChanged: {
        if(focus === false)
            deselect()
    }
}
