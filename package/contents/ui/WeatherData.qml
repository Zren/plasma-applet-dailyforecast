// Version 3

import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore

import org.kde.plasma.private.weather 1.0 as WeatherPlugin

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
	readonly property var data: weatherDataSource.currentData || {}

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

	function parseForecast(dayIndex) {
		var key = "Short Forecast Day " + dayIndex
		var value = data[key]
		var tokens = ["", "weather-none-available", "", "", "", ""]
		if (value) {
			tokens = value.split("|")
			if (tokens.length >= 6) {
				tokens[3] = parseInt(tokens[3], 10)
				tokens[4] = parseInt(tokens[4], 10)
				tokens[5] = parseInt(tokens[5], 10)
				return tokens
			}
		}
		// console.log('parseForecast(' + dayIndex + ')', tokens)
		return tokens
	}

	readonly property var todaysWeather: parseForecast(0) // currentData["Short Forecast Day 0"]
	readonly property string todaysDayLabel: todaysWeather[0]
	readonly property string todaysForecastIcon: todaysWeather[1]
	readonly property string todaysForecastLabel: todaysWeather[2]
	readonly property var todaysTempHigh: todaysWeather[3]
	readonly property var todaysTempLow: todaysWeather[4]
	readonly property var todaysPopPercent: todaysWeather[5]

	function existingWeatherIconName(iconName) {
		// The Util module is only available to other widgets in Plasma 5.13+.
		// So we need to wrap this function to support Plasma 5.12 LTS.
		// * https://github.com/KDE/kdeplasma-addons/blob/Plasma/5.12/applets/weather/plugin/plugin.cpp#L110
		// * https://github.com/KDE/kdeplasma-addons/blob/Plasma/5.13/applets/weather/plugin/plugin.cpp#L110
		if (false && typeof WeatherPlugin["Util"] !== "undefined") {
			// Plasma 5.13+
			return WeatherPlugin.Util.existingWeatherIconName(iconName)
		} else {
			// <= Plasma 5.12
			return iconName
		}
	}

	property string currentConditionIconName: {
		var conditionIconName = data["Condition Icon"] || todaysForecastIcon || null
		return conditionIconName ? existingWeatherIconName(conditionIconName) : "weather-none-available"
	}

	property string currentConditions: {
		return data["Current Conditions"] || todaysForecastLabel || ""
	}

	property var currentTemp: {
		return data["Temperature"] || NaN
	}

	property var dailyForecastModel: {
		var model = []

		var forecastDayCount = parseInt((data && data["Total Weather Days"]) || "", 10)
		if (isNaN(forecastDayCount) || forecastDayCount <= 0) {
			return model
		}

		for (var i = 0; i < forecastDayCount; i++) {
			if (typeof data["Short Forecast Day " + i] === "undefined") {
				// "Total Weather Days" can be "7", however there might not be a "Short Forecast Day 6"
				break
			}
			var tokens = parseForecast(i)
			if (typeof data["Short Forecast Day " + i] === "undefined") {
				// "Total Weather Days" can be "7", however there might not be a "Short Forecast Day 6"
				break
			}
			var item = {
				dayLabel: tokens[0],
				forecastIcon: existingWeatherIconName(tokens[1]),
				forecastLabel: tokens[2],
				tempHigh: tokens[3],
				tempLow: tokens[4],
				popPercent: tokens[5],
			}
			model.push(item)
		}
		return model
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

	// readonly property bool needsConfiguring: false
	// readonly property bool hasData: true
	// readonly property var data: testData
	// property var testData: {
	// 	var data = {}
	// 	data["Short Forecast Day 0"] = "31|weather-few-clouds|Mostly Sunny|17|10|"
	// 	data["Short Forecast Day 1"] = "1|weather-clouds|Partly Sunny|21|18|"
	// 	data["Short Forecast Day 2"] = "2|weather-clouds|Partly Sunny|37|29|"
	// 	data["Short Forecast Day 3"] = "3|weather-overcast|Mostly Cloudy|41|33|"
	// 	data["Short Forecast Day 4"] = "4|weather-showers|Slight Chance Rain|49|41|"
	// 	data["Short Forecast Day 5"] = "5|weather-showers|Slight Chance Rain|55|38|"
	// 	data["Total Weather Days"] = "7"
	// 	return data
	// }
}
