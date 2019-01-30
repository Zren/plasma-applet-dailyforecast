import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore

import org.kde.plasma.private.weather 1.0

QtObject {
	// readonly property string weatherSource: 'bbcukmet|weather|City of London, Greater London|2643741'
	// readonly property string weatherSource: 'envcan|weather|Toronto, ON'
	// readonly property string weatherSource: 'noaa|weather|New York City, Central Park, NY'
	// readonly property string weatherSource: 'wettercom|weather|London, London, GB|GB0KI0101;London'

	// readonly property string weatherSource: 'bbcukmet|weather|Toronto, Canada|6167865' // No Data
	// readonly property string weatherSource: 'noaa|weather|TORONTO CITY, ON' // No Data

	readonly property string weatherSource: plasmoid.configuration.source

	readonly property bool needsConfiguring: !weatherSource
	readonly property bool hasData: !needsConfiguring && !connectingToSource

	readonly property int updateInterval: 30
	property bool connectingToSource: false

	property var weatherDataSource: PlasmaCore.DataSource {
		id: weatherDataSource
		engine: "weather"
		connectedSources: weatherSource
		interval: updateInterval * 60 * 1000

		onConnectedSourcesChanged: {
			// console.log('onConnectedSourcesChanged', connectedSources)
			if (weatherSource) {
				connectingToSource = true
				plasmoid.busy = true
				connectionTimeoutTimer.start()
			}
		}

		readonly property var currentData: data[weatherSource]

		onCurrentDataChanged: {
			if (currentData) {
				connectionTimeoutTimer.stop()
				connectingToSource = false
				plasmoid.busy = false
				// logCurrentData()
			}
		}

		function logCurrentData() {
			var keys = Object.keys(currentData)
			for (var i = 0; i < keys.length; i++) {
				var key = keys[i]
				var value = currentData[key]
				console.log('currentData["' + key + '"]', value)
			}
		}
	}

	property var connectionTimeoutTimer: Timer {
		id: connectionTimeoutTimer

		interval: 60 * 1000 // 1 min
		repeat: false
		onTriggered: {
			connectingToSource = false
			plasmoid.busy = false
			// TODO: inform user
			var sourceTokens = weatherSource.split("|")
			var foo = i18nd("plasma_applet_org.kde.plasma.weather", "Weather information retrieval for %1 timed out.", sourceTokens.value(2))
		}
	}

	readonly property var todaysWeather: {
		var data = weatherDataSource.currentData || {}
		var value = data["Short Forecast Day 0"]
		var tokens = value ? value.split("|") : ["", "weather-none-available", "", "", "", ""]
		tokens[3] = parseInt(tokens[3], 10)
		tokens[4] = parseInt(tokens[4], 10)
		tokens[5] = parseInt(tokens[5], 10)
		// console.log('todaysWeather', tokens)
		return tokens
	}
	readonly property string todaysDayLabel: todaysWeather[0]
	readonly property string todaysForecastIcon: todaysWeather[1]
	readonly property string todaysForecastLabel: todaysWeather[2]
	readonly property var todaysTempHigh: todaysWeather[3]
	readonly property var todaysTempLow: todaysWeather[4]
	readonly property var todaysPopPrecent: todaysWeather[5]

	property string currentConditionIconName: {
		var data = weatherDataSource.currentData || {}
		var conditionIconName = data["Condition Icon"] || todaysForecastIcon || null
		return conditionIconName ? Util.existingWeatherIconName(conditionIconName) : "weather-none-available"
	}

	property string currentConditions: {
		var data = weatherDataSource.currentData || {}
		return data["Current Conditions"] || todaysForecastLabel || ""
	}

	property var currentTemp: {
		var data = weatherDataSource.currentData || {}
		return data["Temperature"] || NaN
	}
	
	// property Timer testTimer: Timer {
	// 	repeat: true
	// 	running: true
	// 	interval: 400
	// 	onTriggered: currentTemp += 1
	// }

	// property Timer testTimer: Timer {
	// 	repeat: true
	// 	running: true
	// 	interval: 1000
	// 	onTriggered: plasmoid.configuration.source = 'envcan|weather|Toronto, ON'
	// }
}
