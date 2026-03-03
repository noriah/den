package polyden

import "slices"

type DrawFunc func(Config) error

type Module interface {
	Id() string
	Aliases() []string
	Draw(Config) error
}

type module struct {
	id      string
	aliases []string
	drawFn  DrawFunc
}

func (m *module) Id() string {
	return m.id
}

func (m *module) Aliases() []string {
	return m.aliases
}

func (m *module) Draw(config Config) error {
	return m.drawFn(config)
}

var store = make([]*module, 0)

func ListModules() []Module {
	out := make([]Module, len(store))
	for i := range store {
		out[i] = store[i]
	}
	return out
}

func GetModule(key string) Module {
	for _, mod := range store {
		if mod.id == key {
			return mod
		}

		if mod.aliases == nil {
			continue
		}

		if slices.Contains(mod.aliases, key) {
			return mod
		}
	}

	return nil
}

func RegisterModule(id string, fn DrawFunc, aliases ...string) {
	store = append(store, &module{
		id:      id,
		aliases: aliases,
		drawFn:  fn,
	})
}
