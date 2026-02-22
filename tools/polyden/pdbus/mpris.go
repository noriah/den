package pdbus

import (
	"context"
	"strings"
	"sync"
	"time"

	"github.com/godbus/dbus/v5"
	"github.com/leberKleber/go-mpris"
	"github.com/pkg/errors"
)

const (
	listNamesMethod = "org.freedesktop.DBus.ListNames"
	baseInterface   = "org.mpris.MediaPlayer2."
	// playerObjectPath = "/org/mpris/MediaPlayer2"
	// playerInterface  = "org.mpris.MediaPlayer2.Player"
)

type MprisStatusChangeAction func(string) error

type Mpris interface {
	Run(context.Context) error
	PlayerName() string
	Status() string
	Artist() string
	Title() string
	Duration() int64
	Position() int64
}

var _ Mpris = &mprisBlock{}

type MprisOptions struct {
	StatusChangeAction MprisStatusChangeAction
}

func NewMpris(opts ...*MprisOptions) Mpris {

	block := &mprisBlock{
		player:   "unknown",
		status:   "unknown",
		artist:   "none",
		title:    "none",
		duration: 0,
		position: 0,
	}

	if len(opts) <= 0 {
		return block
	}

	opt := opts[0]

	block.statusChangeAction = opt.StatusChangeAction

	return block
}

type mprisBlock struct {
	mu sync.RWMutex

	player string
	status string

	artist string
	title  string

	duration int64
	position int64

	statusChangeAction MprisStatusChangeAction

	conn *dbus.Conn
}

func listPlayers(conn *dbus.Conn, ctx context.Context) ([]string, error) {
	var names []string

	err := conn.BusObject().CallWithContext(ctx, listNamesMethod, 0).Store(&names)
	if err != nil {
		return nil, err
	}

	playerNames := make([]string, 0)

	for _, name := range names {
		if strings.HasPrefix(name, baseInterface) {
			playerNames = append(playerNames, name)
		}
	}

	return playerNames, nil
}

func rawPlayerName(player string) string {
	name, _ := strings.CutPrefix(player, baseInterface)
	return name
}

func (m *mprisBlock) updateCurrentPlayer(ctx context.Context) error {
	allPlayers, err := listPlayers(m.conn, ctx)
	if err != nil {
		return err
	}

	// TODO: be aware of removed player when more than one is still active

	switch len(allPlayers) {
	case 0:
		m.player = "none"
		return nil
	case 1:
		m.player = allPlayers[0]
		return nil
	default:
	}

	for _, player := range allPlayers {
		p := mpris.NewPlayerWithConnection(player, m.conn)
		status, err := p.PlaybackStatus()
		if err != nil {
			return err
		}

		if status == mpris.PlaybackStatusPlaying {
			m.player = player
			return nil
		}
	}

	return nil
}

func (m *mprisBlock) updateStatus() error {
	if m.player == "none" || m.player == "unknown" {
		m.status = "none"
		return nil
	}

	p := mpris.NewPlayerWithConnection(m.player, m.conn)

	status, err := p.PlaybackStatus()
	if err != nil {
		return err
	}

	m.status = string(status)

	return nil
}

func (m *mprisBlock) updateMetadata() error {
	switch m.status {
	case "Stopped", "unknown", "none":
		m.artist = "none"
		m.title = "none"
		m.duration = 0
		m.position = 0
		return nil

	default:
	}

	p := mpris.NewPlayerWithConnection(m.player, m.conn)

	metadata, err := p.Metadata()
	if err != nil {
		return err
	}

	artists, _ := metadata.XESAMArtist()

	switch len(artists) {
	case 0:
		m.artist = "n/a"
	case 1:
		m.artist = artists[0]
	default:
		m.artist = artists[0]
	}

	m.title, _ = metadata.XESAMTitle()

	vl := metadata["mpris:length"].Value()
	if vl == nil {
		m.duration = 0
	} else {
		m.duration = int64(vl.(uint64))
	}

	m.position, err = p.Position()
	if err != nil {
		m.position = 0
	}

	return nil
}

func (m *mprisBlock) update(ctx context.Context) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if err := m.updateCurrentPlayer(ctx); err != nil {
		return errors.Wrap(err, "failed to update player")
	}

	status := m.status
	if err := m.updateStatus(); err != nil {
		return errors.Wrap(err, "failed to update status")
	}
	if m.status != status && m.statusChangeAction != nil {
		if err := m.statusChangeAction(m.status); err != nil {
			return err
		}
	}

	if err := m.updateMetadata(); err != nil {
		return errors.Wrap(err, "failed to update metadata")
	}

	return nil
}

func (m *mprisBlock) Run(ctx context.Context) error {
	t := time.NewTicker(time.Millisecond * 50)
	defer t.Stop()

	conn, err := dbus.ConnectSessionBus()
	if err != nil {
		return err
	}
	defer conn.Close()

	m.conn = conn

	for {
		if err := m.update(ctx); err != nil {
			return err
		}

		select {
		case <-ctx.Done():
			return nil
		case <-t.C:
		}
	}
}

func (m *mprisBlock) PlayerName() string {
	m.mu.RLock()
	defer m.mu.RUnlock()
	return rawPlayerName(m.player)
}

func (m *mprisBlock) Status() string {
	m.mu.RLock()
	defer m.mu.RUnlock()
	return m.status
}

func (m *mprisBlock) Artist() string {
	m.mu.RLock()
	defer m.mu.RUnlock()
	return m.artist
}

func (m *mprisBlock) Title() string {
	m.mu.RLock()
	defer m.mu.RUnlock()
	return m.title
}

func (m *mprisBlock) Duration() int64 {
	m.mu.RLock()
	defer m.mu.RUnlock()
	return m.duration
}

func (m *mprisBlock) Position() int64 {
	m.mu.RLock()
	defer m.mu.RUnlock()
	return m.position
}
