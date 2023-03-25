package modules

import (
	"errors"
	"fmt"

	"github.com/noriah/den/src/polyden"
	"github.com/noriah/den/src/polyden/util"
)

func init() {
	polyden.RegisterModule(
		/* id= */ "weather-aqi",
		/* fn= */ drawWeatherAqi,
		/* aliases= */ "aqi")
}

func drawWeatherAqi(config polyden.Config) error {
	symbol := ''
	apiKey := config.GetString("weather.aqi.apiKey")
	city := config.GetString("weather.aqi.city")

	url := fmt.Sprintf("https://api.waqi.info/feed/%s/?token=%s", city, apiKey)

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
		color, polyden.Font(3, string(symbol))),
		fmt.Sprintf("%-2d", aqi))

	return nil
}
