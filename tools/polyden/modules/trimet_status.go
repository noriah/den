package modules

import (
	"fmt"
	"strconv"
	"strings"
	"text/template"
	"time"

	"github.com/noriah/den/src/polyden"
	"github.com/noriah/den/src/polyden/util"
)

func init() {
	polyden.RegisterModule(
		/* id= */ "trimet-status",
		/* fn= */ drawTrimetStatus,
		/* aliases= */ "trimet", "trimet-arrival")
}

const (
	trimetArrivalsApi = "https://developer.trimet.org/ws/v2/arrivals"
)

const (
	iconTransitUnknown = '󰪙' // bus_alert
	iconBus            = '󰃧' // bus
	iconMax            = '󰔭' // tram
	iconStreetcar      = '󰿧' // tram_side
)

const (
	routeTypeBus       = "Bus"
	routeTypeMax       = "Light Rail"
	routeTypeStreetcar = "Streetcar"
)

var trimetIconTypeMap = map[string]rune{
	routeTypeBus:       iconBus,
	routeTypeMax:       iconMax,
	routeTypeStreetcar: iconStreetcar,
}

// see https://developer.trimet.org/ws_docs/arrivals2_ws.shtml
type trimetArrival struct {
	Type         string `json:"routeSubType"`
	Color        string `json:"routeColor"`
	Sign         string `json:"shortSign"`
	Status       string `json:"status"`
	DepartTime   int64  `json:"estimated"`
	Location     int    `json:"locid"`
	InRoute      bool   `json:"departed"`
	StreetCarApi bool   `json:"streetCar"`
	DropOffOnly  bool   `json:"dropOffOnly"`
}

func (ta *trimetArrival) String() string {
	if ta == nil {
		return " n/a "
	}

	fmt.Println(ta.Color)
	colorU64, err := strconv.ParseUint(ta.Color, 16, 32)
	if err != nil {
		panic(err)
	}
	color := polyden.Color(colorU64)

	icon := iconTransitUnknown
	if i, ok := trimetIconTypeMap[ta.Type]; ok {
		icon = i
	}
	iconText := polyden.FgColor(color, polyden.Font(3, string(icon)))

	departTime := time.Unix(ta.DepartTime/1000, 0)
	until := time.Until(departTime).Minutes()

	return fmt.Sprintf("%s %d min", iconText, int(until))
}

type trimetArrivals []*trimetArrival

func (tr trimetArrivals) closestArrival() *trimetArrival {
	switch len(tr) {
	case 0:
		return nil
	case 1:
		return tr[0]
	default:
	}

	prev := tr[0]
	for _, v := range tr[1:] {
		if prev.DepartTime > v.DepartTime {
			prev = v
		}
	}

	return prev
}

func drawTrimetStatus(config polyden.Config) error {
	appId := config.GetString("trimet.appId")
	locIds := config.GetStringList("trimet.stopIds")
	format := config.GetString("trimet.format")

	fetchUrl := fmt.Sprintf("%s?appID=%s&locIDs=%s",
		trimetArrivalsApi,
		appId,
		strings.Join(locIds, ","))

	type respData struct {
		Data struct {
			Arrivals []*trimetArrival `json:"arrival"`
		} `json:"resultSet"`
	}

	data := &respData{}

	err := util.GetHttpJson(fetchUrl, data)
	if err != nil {
		return err
	}

	allArrivalData := make(map[string]trimetArrivals)

	for _, entry := range data.Data.Arrivals {
		if entry.Status != "estimated" {
			continue
		}

		loc := strconv.Itoa(entry.Location)
		if _, ok := allArrivalData[loc]; !ok {
			allArrivalData[loc] = make(trimetArrivals, 0)
		}

		allArrivalData[loc] = append(allArrivalData[loc], entry)
	}

	arrivalData := make(map[string]*trimetArrival)
	for k, v := range allArrivalData {
		arrivalData["s"+k] = v.closestArrival()
	}

	t, err := template.New("trimet").Parse(format)
	if err != nil {
		return err
	}

	buf := new(strings.Builder)
	err = t.Execute(buf, arrivalData)
	fmt.Println(buf)

	return nil
}
