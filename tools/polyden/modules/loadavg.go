package modules

import (
	"fmt"
	"strings"

	"github.com/noriah/den/src/polyden"
	"github.com/noriah/den/src/polyden/util"
)

func init() {
	polyden.RegisterModule(
		/* id= */ "system-load-average",
		/* fn= */ drawSystemLoadAvg,
		/* aliases= */ "system-loadavg", "loadavg")
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
