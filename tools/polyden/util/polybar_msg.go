package util

import (
	"fmt"
	"os/exec"

	"github.com/pkg/errors"
)

func PolybarMsg(action, module, data string) error {
	args := []string{action, module, data}
	cmd := exec.Command("polybar-msg", args...)

	out, err := cmd.CombinedOutput()
	if err != nil {

		wrapMsg := fmt.Sprintf("error in polybar-msg - %s -- ", string(out))
		return errors.Wrap(err, wrapMsg)
	}

	return nil
}
