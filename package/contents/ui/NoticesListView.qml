// Version 4

import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents3
import org.kde.kirigami as Kirigami

ColumnLayout {
	id: noticesListView
	property alias model: repeater.model

	spacing: Kirigami.Units.smallSpacing

	property int horizontalAlignment: Text.AlignLeft
	property color backgroundColor: "#800"
	property color borderColor: "#800"
	property color textColor: "#eee"

	state: "Watches"
	states: [
		// Watches = "warning" yellow/orange
		State {
			name: "Watches"
			PropertyChanges {
				target: noticesListView
				backgroundColor: "#856404"
				borderColor: "#755400"
				textColor: "#fff3cd"
			}
		},
		// Warnings = "danger" red
		State {
			name: "Warnings"
			PropertyChanges {
				target: noticesListView
				backgroundColor: "#721c24"
				borderColor: "#620c14"
				textColor: "#f8d7da"
			}
		}
	]

	Repeater {
		id: repeater
		model: []

		Rectangle {
			id: noticeItem
			Layout.fillWidth: true
			property int horPadding: 4 * Screen.devicePixelRatio
			property int vertPadding: 2 * Screen.devicePixelRatio
			implicitHeight: vertPadding + noticeLabel.implicitHeight + vertPadding

			color: getStateColor(noticesListView.backgroundColor)
			border.color: getStateColor(noticesListView.borderColor)
			property color labelColor: getStateColor(noticesListView.textColor)

			function getStateColor(c) {
				return noticeMouseArea.containsMouse ? Qt.lighter(c, 1.1) : c
			}

			border.width: 1 * Screen.devicePixelRatio
			radius: 3 * Screen.devicePixelRatio


			MouseArea {
				id: noticeMouseArea
				anchors.fill: parent
				hoverEnabled: true
				cursorShape: Qt.PointingHandCursor
				onClicked: Qt.openUrlExternally(modelData.url)
			}

			PlasmaComponents3.Label {
				id: noticeLabel
				text: modelData.description
				color: noticeItem.labelColor
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				anchors.leftMargin: noticeItem.horPadding
				anchors.right: parent.right
				anchors.rightMargin: noticeItem.horPadding
				elide: Text.ElideRight
				horizontalAlignment: noticesListView.horizontalAlignment
			}
		}
	}
}
