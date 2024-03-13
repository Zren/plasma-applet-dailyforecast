import QtQuick
import QtQuick.Layouts
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents3
import org.kde.plasma.plasmoid

import "./libweather" as LibWeather

PlasmoidItem {
	id: widget

	LibWeather.WeatherData {
		id: weatherData
	}

	Plasmoid.icon: weatherData.currentConditionIconName
	toolTipMainText: weatherData.currentConditions

	fullRepresentation: Item {
		readonly property bool isDesktopContainment: plasmoid.location == PlasmaCore.Types.Floating
		Plasmoid.backgroundHints: isDesktopContainment && !plasmoid.configuration.showBackground ? PlasmaCore.Types.NoBackground : PlasmaCore.Types.DefaultBackground

		property Item contentItem: weatherData.needsConfiguring ? configureButton : forecastLayout
		Layout.preferredWidth: 400 * Screen.devicePixelRatio
		Layout.preferredHeight: 200 * Screen.devicePixelRatio
		width: Layout.preferredWidth
		height: Layout.preferredHeight

		PlasmaComponents3.Button {
			id: configureButton
			anchors.centerIn: parent
			visible: weatherData.needsConfiguring
			text: i18nd("plasma_applet_org.kde.plasma.weather", "Set location…")
			onClicked: Plasmoid.internalAction("configure").trigger()
			Layout.minimumWidth: implicitWidth
			Layout.minimumHeight: implicitHeight
		}

		ForecastLayout {
			id: forecastLayout
			anchors.fill: parent
			visible: !weatherData.needsConfiguring
		}

	}

	Plasmoid.contextualActions: [
		PlasmaCore.Action {
			text: i18n("Refresh")
			icon.name: "view-refresh"
			onTriggered: weatherData.refresh()
		}
	]

	Component.onCompleted: {
		// Plasmoid.internalAction("configure").trigger()
	}
}
