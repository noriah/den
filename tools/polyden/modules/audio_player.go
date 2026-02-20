package modules

import (
	"context"
	"fmt"
	"os"
	"os/signal"
	"strings"
	"time"

	"github.com/noriah/den/src/polyden"
	"github.com/noriah/den/src/polyden/pdbus"
	"github.com/noriah/den/src/polyden/util"
)

func init() {
	polyden.RegisterModule(
		/* id= */ "audio-player-status",
		/* fn= */ drawAudioPlayerStatus,
		/* aliases= */ "audio-player", "music-player")
}

type audioPlayerIcon struct {
	name  string
	icon  rune
	color polyden.Color
}

var unknownPlayerIcon = &audioPlayerIcon{
	icon:  '󰎈',
	color: 0x3399ff,
}

var audioPlayerIconMap = map[string]*audioPlayerIcon{
	"spotify": {
		icon:  '󰓇',
		color: 0x1db954,
	},
	"vlc": {
		icon:  '󰕼',
		color: 0xff9800,
	},
}

type audioPlayerStatus struct {
	conn pdbus.Mpris
}

var _ util.ScrollerTextSource = &audioPlayerStatus{}

func (a *audioPlayerStatus) getMetadata() string {
	player := a.conn.PlayerName()
	if _, found := audioPlayerIconMap[player]; !found {
		return fmt.Sprintf("-\\_/-\\_/-%s-\\_/-\\_/-", player)
	}

	return fmt.Sprintf("%s - %s", a.conn.Title(), a.conn.Artist())
}

// TODO: controls

func (a *audioPlayerStatus) Text() (string, error) {
	status := a.conn.Status()
	switch status {
	case "none":
		return "No player is running", nil
	case "Stopped":
		return "Nothing is playing", nil
	default:
		return a.getMetadata(), nil
	}
}

func (a *audioPlayerStatus) BeforeText() (string, error) {
	player := a.conn.PlayerName()
	icon := unknownPlayerIcon

	if found, ok := audioPlayerIconMap[player]; ok {
		icon = found
	}

	builder := new(strings.Builder)
	builder.WriteString(polyden.FontChange(4))
	builder.WriteString(polyden.FgColor(icon.color, fmt.Sprintf("%c ", icon.icon)))
	builder.WriteString(polyden.FontChange(7))

	return builder.String(), nil
}

func (a *audioPlayerStatus) getTimecode() string {
	status := a.conn.Status()
	switch status {
	default:
		return "--:--/--:--"
	case "Playing", "Paused":
	}

	duration := a.conn.Duration() / 1_000_000
	position := a.conn.Position() / 1_000_000
	tDur := time.Unix(duration, 0).Format("04:05")
	tPos := time.Unix(position, 0).Format("04:05")

	return fmt.Sprintf("%s/%s", tPos, tDur)
}

func (a *audioPlayerStatus) AfterText() (string, error) {
	return fmt.Sprintf(" | %s%s", a.getTimecode(), polyden.FontReset()), nil
}

func (a *audioPlayerStatus) PadText() (string, error) {
	return " <!> ", nil
}

func updatePlayerControls(status string) error {
	data := "1"

	switch status {
	case "Playing":
		data = "2"
	default:
		data = "1"
	}

	return util.PolybarMsg("hook", "player-controls", data)
}

func drawAudioPlayerStatus(config polyden.Config) error {
	ctx, cancelCause := context.WithCancelCause(context.Background())
	ctx, cancel := signal.NotifyContext(ctx, os.Interrupt, os.Kill)
	defer cancel()

	mprisConn := pdbus.NewMpris(&pdbus.MprisOptions{
		StatusChangeAction: updatePlayerControls,
	})

	textWidth := config.GetIntDefault("audioplayer.textWidth", 30)
	scrollDelay := time.Millisecond * time.Duration(config.GetIntDefault("audioplayer.scrollDelay", 250))

	t := time.NewTicker(scrollDelay)
	defer t.Stop()

	playerStatus := &audioPlayerStatus{
		conn: mprisConn,
	}

	scroller := util.NewScroller(playerStatus, textWidth)

	go func() {
		if err := mprisConn.Run(ctx); err != nil {
			cancelCause(err)
			return
		}
		cancel()
	}()

	for {
		err := scroller.Update()
		if err != nil {
			return err
		}

		output, err := scroller.Output()
		if err != nil {
			return err
		}

		fmt.Println(output)

		if status := mprisConn.Status(); status == "Playing" {
			scroller.Step()
		}

		select {
		case <-ctx.Done():
			if ctx.Err() != nil && context.Cause(ctx) != ctx.Err() {
				return context.Cause(ctx)
			}
			return nil

		case <-t.C:
		}
	}
}
