import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.11
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kirigami as Kirigami
import org.kde.kquickcontrols as KControls

Kirigami.FormLayout {
  id: appearanceRoot

  property alias cfg_fontSize: sizeFontSpinBox.value
  property alias cfg_textColorFromTheme: themeColor.checked
  property alias cfg_textColor: textColor.color

  SpinBox {
    id: sizeFontSpinBox
    Kirigami.FormData.label: i18n("Font Size")
    from: 0
    to: 300
  }

  CheckBox {
    id: themeColor
    Kirigami.FormData.label: i18n("Use text color from system theme")
  }

  KControls.ColorButton {
    id: textColor
    Kirigami.FormData.label: i18n("Use custom color")
    showAlphaChannel: true
  }


}

