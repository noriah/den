package modules

import (
	"errors"
	"fmt"

	"github.com/noriah/den/src/polyden"
	"github.com/noriah/den/src/polyden/util"
)

const (
	WEATHER_AQI_API      = "https://api.waqi.info/feed"
	WEATHER_FORECAST_API = "https://api.openweathermap.org/data/2.5"
)

func init() {
	polyden.RegisterModule(
		/* id= */ "weather-aqi",
		/* fn= */ drawWeatherAqi,
		/* aliases= */ "aqi")
	polyden.RegisterModule(
		/* id= */ "weather-forecast",
		/* fn= */ drawWeatherForecast,
		/* aliases= */ "forecast")
}

func drawWeatherAqi(config polyden.Config) error {
	symbol := ''
	fontId := config.GetIntDefault("fonts.icons", 3)
	apiKey := config.GetString("weather.aqi.apiKey")
	city := config.GetString("weather.aqi.city")

	url := fmt.Sprintf("%s/%s/?token=%s", WEATHER_AQI_API, city, apiKey)

	type respData struct {
		Status string `json:"status"`
		Data   struct {
			Aqi int `json:"aqi"`
		} `json:"data"`
	}

	data := &respData{}

	if err := util.GetHttpJson(url, data); err != nil {
		return err
	}

	if data.Status != "ok" {
		return errors.New("not okay status")
	}

	aqi := data.Data.Aqi

	var color polyden.Color

	switch {
	case aqi < 50:
		color = polyden.Color(0x68_9f_38) // good
	case aqi < 100:
		color = polyden.Color(0xfb_c0_2d) // moderate
	case aqi < 150:
		color = polyden.Color(0xf5_7c_00) // unhealthy (for sensitive groups)
	case aqi < 200:
		color = polyden.Color(0xc5_39_29) // unhealthy
	case aqi < 300:
		color = polyden.Color(0xad_14_57) // very unhealthy
	default:
		color = polyden.Color(0x88_0e_50) // hazardous
	}

	fmt.Printf("%s %3s\n", polyden.FgColor(
		color, polyden.Font(fontId, string(symbol))),
		fmt.Sprintf("%-2d", aqi))

	return nil
}

func drawWeatherForecast(config polyden.Config) error {
	degSym := '°'
	fontId := config.GetIntDefault("fonts.icons", 3)
	apiKey := config.GetString("weather.forecast.apiKey")
	city := config.GetString("weather.forecast.city")
	units := config.GetStringDefault("weather.forecast.units", "both")

	url := fmt.Sprintf("%s/weather?appid=%s&id=%s&units=imperial",
		WEATHER_FORECAST_API, apiKey, city)

	type respData struct {
		Base string `json:"base"`
		Main struct {
			Temp float32 `json:"temp"`
		} `json:"main"`
		Weather []struct {
			Icon string `json:"icon"`
		} `json:"weather"`
	}

	data := &respData{}

	if err := util.GetHttpJson(url, data); err != nil {
		return err
	}

	if data.Base != "stations" {
		return errors.New("bad forecast response")
	}

	iconData := data.Weather[0].Icon
	iconRune := getWeatherForecastIcon(iconData)
	iconStr := polyden.Font(fontId, string(iconRune))

	tempF := data.Main.Temp
	tempFStr := fmt.Sprintf("%.0f%c", tempF, degSym)

	tempC := (tempF - 32.0) * (5.0 / 9.0)
	tempCStr := fmt.Sprintf("%.0f%c", tempC, degSym)

	switch units {
	case "c", "celcius":
		fmt.Printf("%s  %s\n", iconStr, tempCStr)
	case "f", "fahrenheit":
		fmt.Printf("%s  %s\n", iconStr, tempFStr)
	case "cfirst":
		fmt.Printf("%s  %-3s(%s)\n", iconStr, tempCStr, tempFStr)
	case "ffirst":
		fmt.Printf("%s  %-3s(%s)\n", iconStr, tempFStr, tempCStr)
	default:
		fmt.Printf("%s  %-3s(%s)\n", iconStr, tempCStr, tempFStr)
	}

	return nil
}

func getWeatherForecastIcon(id string) rune {
	switch id {
	case "01d":
		return '' // day-sunny
	case "01n":
		return '' // night-clear
	case "02d":
		return '' // day-cloudy
	case "02n":
		return '' // nigh-alt-cloudy
	case "03d", "03n":
		return '' // cloud
	case "04d":
		return '' // day-cloudy
	case "04n":
		return '' // night-cloudy
	case "09d", "09n":
		return '' // rain-wind
	case "10d":
		return '' // day-rain
	case "10n":
		return '' // night-rain
	case "11d":
		return '' // day-lightning
	case "11n":
		return '' // night-alt-lightning
	case "13d":
		return '' // day-snow
	case "13n":
		return '' // night-alt-snow
	case "50d":
		return '' // day-fog
	case "50n":
		return '' // night-fog
	default:
		return '' // day-sunny
	}
}
