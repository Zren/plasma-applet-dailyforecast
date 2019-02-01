import QtQuick 2.7
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import org.kde.plasma.private.weather 1.0

Item {
	id: widget

	WeatherData {
		id: weatherData
	}

	Plasmoid.icon: weatherData.currentConditionIconName
	Plasmoid.toolTipMainText: weatherData.currentConditions

	Plasmoid.fullRepresentation: Item {
		readonly property bool isDesktopContainment: plasmoid.location == PlasmaCore.Types.Floating
		Plasmoid.backgroundHints: isDesktopContainment && !plasmoid.configuration.showBackground ? PlasmaCore.Types.NoBackground : PlasmaCore.Types.DefaultBackground

		property Item contentItem: weatherData.needsConfiguring ? configureButton : forecastLayout
		implicitWidth: contentItem.implicitWidth
		implicitHeight: contentItem.implicitHeight
		Layout.minimumWidth: implicitWidth
		Layout.minimumHeight: implicitHeight

		PlasmaComponents.Button {
			id: configureButton
			anchors.centerIn: parent
			visible: weatherData.needsConfiguring
			text: i18ndc("plasma_applet_org.kde.plasma.weather", "@action:button", "Configure...")
			onClicked: plasmoid.action("configure").trigger()
		}

		DailyForecastView {
			id: forecastLayout
		}

	}


	Component.onCompleted: {
		// plasmoid.action("configure").trigger()
	}
}
