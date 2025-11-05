import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.11
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
  id: generalConfig

  property alias cfg_dayInitial: initialValue.value
  property alias cfg_latinAlphabet: latinAlphabet.checked
  QtObject {
    id: initialValue
    property var value
  }

  CheckBox {
    id: latinAlphabet
    Kirigami.FormData.label: i18n("Maintain formatting with Latin alphabet:")
  }

    ComboBox {
      textRole: "text"
      valueRole: "value"
      id: initial
      Kirigami.FormData.label: i18n("First day of the week")
      model: [
        {text: i18n("Sunday"), value: 0},
        {text: i18n("Monday"), value: 1},
        {text: i18n("Tuesday"), value: 2},
        {text: i18n("Wednesday"), value: 3},
        {text: i18n("Thursday"), value: 4},
        {text: i18n("Friday"), value: 5},
        {text: i18n("Saturday"), value: 6},
      ]
      onActivated: initialValue.value = currentValue
      Component.onCompleted: currentIndex = indexOfValue(initialValue.value)
    }
}
