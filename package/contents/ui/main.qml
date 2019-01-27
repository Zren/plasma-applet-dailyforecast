import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
	id: widget

	Plasmoid.compactRepresentation: MouseArea {
		readonly property bool inPanel: (plasmoid.location == PlasmaCore.Types.TopEdge
			|| plasmoid.location == PlasmaCore.Types.RightEdge
			|| plasmoid.location == PlasmaCore.Types.BottomEdge
			|| plasmoid.location == PlasmaCore.Types.LeftEdge)

		Layout.minimumWidth: {
			switch (plasmoid.formFactor) {
			case PlasmaCore.Types.Vertical:
				return 0
			case PlasmaCore.Types.Horizontal:
				return height
			default:
				return units.gridUnit * 3
			}
		}

		Layout.minimumHeight: {
			switch (plasmoid.formFactor) {
			case PlasmaCore.Types.Vertical:
				return width
			case PlasmaCore.Types.Horizontal:
				return 0
			default:
				return units.gridUnit * 3
			}
		}

		Layout.maximumWidth: inPanel ? units.iconSizeHints.panel : -1
		Layout.maximumHeight: inPanel ? units.iconSizeHints.panel : -1

		PlasmaCore.IconItem {
			id: icon
			anchors.fill: parent
			source: plasmoid.icon
		}

		onClicked: plasmoid.expanded = !plasmoid.expanded
	}

	Plasmoid.fullRepresentation: Item {

	}



	Component.onCompleted: {

	}
}
