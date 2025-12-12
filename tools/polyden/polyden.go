package polyden

type DrawFunc func(Config) error

type Module interface {
	Id() string
	Aliases() []string
	Draw(Config) error
}

type module struct {
	id      string
	aliases []string
	Draw    DrawFunc
}

var store = make([]*module, 0)

func GetModule(key string) *module {
	for _, mod := range store {
		if mod.id == key {
			return mod
		}

		if mod.aliases == nil {
			continue
		}

		for _, a := range mod.aliases {
			if a == key {
				return mod
			}
		}
	}

	return nil
}

func RegisterModule(id string, fn DrawFunc, aliases ...string) {
	store = append(store, &module{
		id:      id,
		aliases: aliases,
		Draw:    fn,
	})
}

func (m *module) Id() string {
	return m.id
}

func (m *module) Aliases() []string {
	return m.aliases
}
