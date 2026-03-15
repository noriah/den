package modules

import (
	"fmt"
	"strconv"
	"strings"
	"time"

	"github.com/noriah/den/src/polyden"
	"github.com/noriah/den/src/polyden/util"
)

func init() {
	polyden.RegisterModule(
		/* id= */ "system-load-average",
		/* fn= */ drawSystemLoadAvg,
		/* aliases= */ "system-loadavg", "loadavg")
	polyden.RegisterModule(
		/* id= */ "system-uptime",
		/* fn= */ drawSystemUptime,
		/* aliases= */ "uptime")
}

func drawSystemLoadAvg(_ polyden.Config) error {
	data, err := util.ReadFile("/proc/loadavg")
	if err != nil {
		return err
	}

	p := strings.Split(string(data), " ")

	fmt.Printf("%s/%s/%s / %s / %s\n", p[0], p[1], p[2], p[3], p[4])

	return nil
}

func drawSystemUptime(_ polyden.Config) error {
	data, err := util.ReadFile("/proc/uptime")
	if err != nil {
		return err
	}

	p := strings.Split(string(data), " ")

	p2 := make([]int64, 2)
	for i, s := range strings.Split(p[0], ".") {
		if p2[i], err = strconv.ParseInt(s, 10, 32); err != nil {
			return err
		}
	}

	t := time.Unix(p2[0], p2[1]*10000000).UTC()

	diff := t.Sub(time.Unix(0, 0))

	fmt.Printf(
		"%02dd %02dh %02dm %02ds\n",
		int(diff.Hours()/24),
		t.Hour(),
		t.Minute(),
		t.Second(),
	)

	return nil
}
