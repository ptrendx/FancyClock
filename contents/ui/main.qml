/*
 SPDX-FileCopyrightText: zayronxio
 SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.15
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.4 as Kirigami
import Qt5Compat.GraphicalEffects
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.plasma5support 2.0 as Plasma5Support
import "js/Texts.js" as Texts

PlasmoidItem {
  id: root

  property var fSize: plasmoid.configuration.fontSize
  property var daySize: fSize*1.3
  property int firstday: plasmoid.configuration.dayInitial
  property bool latinAlphabet: Plasmoid.configuration.latinAlphabet
  property int numLettersInDay: 1
  property var textColor: Kirigami.Theme.textColor

  property var currentDate: new Date();

  property bool showSeconds: false

  preferredRepresentation: fullRepresentation
  Plasmoid.backgroundHints: "NoBackground"

  // property string codelang: ((Qt.locale().name)[0]+(Qt.locale().name)[1])
  property string codelang: Qt.locale().name.substring(0,2)


  Plasma5Support.DataSource {
    id: timeDataSource
    engine: "time"
    connectedSources: ["Local"]
    intervalAlignment: root.showSeconds ? Plasma5Support.Types.NoAlignment : Plasma5Support.Types.AlignToMinute
    interval: root.showSeconds ? 1000 : 60000

    onDataChanged: {
      root.currentDate = new Date(data["Local"]["DateTime"]);
      console.log("Got date: ", root.currentDate);
    }
    Component.onCompleted: {
      dataChanged();
    }
  }

  FontLoader {
    id: fontB
    source: "../fonts/LeagueGothic-Condensed.ttf"
  }
  FontLoader {
    id: england
    source: "../fonts/england.ttf"
  }
  FontLoader {
    id: oswald
    source: "../fonts/Oswald-VariableFont_wght.ttf"
  }
  FontLoader {
    id: quicksand
    source: "../fonts/Quicksand-VariableFont_wght.ttf"
    // source: "../fonts/Libertinus_Mono/LibertinusMono-Regular.ttf"
  }

  function abbreviate(text, maxLength) {
    if (text.length > maxLength) {
      return text.substring(0, maxLength) + "..."
    } else {
      return text
    }
  }

  function getDayText(b) {
    return Texts.getDayWeekText(codelang, b)
  }

  function getDayFromIndex(index) {
    return (index + firstday) % 7;
  }

  function getColor(index, date) {
    const day = getDayFromIndex(index);
    if (date.getDay() === day) {
      return textColor
    } else {
      return "transparent"
    }
  }

  function isMaskActive(index, date) {
    const day = getDayFromIndex(index);
    if (date.getDay() === day) {
      return true;
    } else {
      return false;
    }
  }

  fullRepresentation: Item {
    Layout.minimumWidth: datefull.width
    Layout.minimumHeight: datefull.height
    Layout.preferredWidth: Layout.minimumWidth
    Layout.preferredHeight: Layout.minimumHeight

    ColumnLayout {
      id:  datefull
      anchors.centerIn: parent
      Layout.minimumWidth: root.Layout.minimumWidth
      Layout.minimumHeight: root.Layout.minimumHeight
      Layout.preferredWidth: daysRow.width
      Layout.preferredHeight: cal_rect.height + daysRow.height + clock.height
      spacing: 0
      Row {
        id: daysRow
        width: fSize*13
        height: daySize
        spacing: daySize / 2
        Layout.alignment: Qt.AlignHCenter
        Repeater {
          id: daysBubbleRepeater
          model: 7
          Rectangle {
            required property int index
            color: getColor(index, root.currentDate)
            width: daySize
            height: daySize
            radius: 100
            layer.enabled: isMaskActive(index, root.currentDate)
            layer.effect: OpacityMask {
              maskSource: mask
              invert: true
            }
            Rectangle {
              id: mask
              width: parent.width
              height: parent.height
              color: "transparent"
              visible: !isMaskActive(index, root.currentDate)
              Kirigami.Heading {
                id: dayText
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: getDayText(getDayFromIndex(index)).substring(0, numLettersInDay)
                color: textColor
                font.pixelSize: fSize
                font.capitalization: Font.Capitalize
                font.bold: true
              }
            }
          }
        }
      }

      Rectangle {
        id: cal_rect
        Layout.fillWidth: true
        height: (monthText.height+daysText.height)*.7
        color: "transparent"
        Layout.alignment: Qt.AlignHCenter
        Kirigami.Heading {
          id: daysText
          anchors.topMargin: -fSize*.9
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.top: parent.top
          text: Qt.formatDateTime(root.currentDate, "dd")
          font.pixelSize: fSize * 3
          font.family: oswald.name
          color: textColor
          font.bold: true
        }
        Kirigami.Heading {
          id: monthText
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.bottom: parent.bottom
          text: Texts.getMonthText(codelang, (Qt.formatDateTime(root.currentDate, "M") - 1))
          font.pixelSize: fSize * 4
          font.family: england.name
          color: textColor
          font.capitalization: Font.Capitalize
        }
      }

      RowLayout {
        id: clock
        Layout.minimumWidth: hours.width*2.4
        Layout.minimumHeight: hours.height
        Layout.preferredWidth: Layout.minimumWidth
        Layout.preferredHeight: Layout.minimumHeight
        Layout.alignment: Qt.AlignHCenter
        spacing: 0

        Item {
          Layout.fillWidth: true
        }

        Kirigami.Heading{
          id: hours
          color: textColor
          font.pixelSize: fSize * 4
          text: Qt.formatDateTime(root.currentDate, "h")
          font.family: quicksand.name
        }

        Rectangle {
          color: "transparent"
          width: (hours.width)*.3
          Layout.preferredHeight: hours.height
          Layout.alignment: Qt.AlignHCenter
          Rectangle {
            color: textColor
            width: 1.3
            height: parent.height
            anchors.centerIn: parent
          }
        }

        Kirigami.Heading{
          id: minutesText
          color: textColor
          font.pixelSize: fSize * 4
          text: Qt.formatDateTime(root.currentDate, "mm")
          font.family: quicksand.name
        }

        Item {
          Layout.fillWidth: true
        }
      }
    }
  }
}



