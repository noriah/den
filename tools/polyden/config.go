package polyden

import (
	"log"
	"os"
	"strings"

	"gopkg.in/yaml.v3"
)

type Config interface {
	Load(filePath string) error
	GetString(key string) string
	GetStringDefault(key, def string) string
	GetInt(key string) int
	GetIntDefault(key string, def int) int
}

type config struct {
	filePath string
	data     map[string]any
}

func NewConfig() *config {
	return &config{}
}

func (c *config) Load(filePath string) error {
	c.filePath = filePath
	data, err := os.ReadFile(os.ExpandEnv(filePath))
	if err != nil {
		return err
	}

	return yaml.Unmarshal(data, &c.data)
}

func (c *config) GetString(key string) string {
	return c.getForKey(key, true).(string)
}

func (c *config) GetStringDefault(key, def string) string {
	if val := c.getForKey(key, false); val != nil {
		return val.(string)
	}
	return def
}

func (c *config) GetInt(key string) int {
	return c.getForKey(key, true).(int)
}

func (c *config) GetIntDefault(key string, def int) int {
	if val := c.getForKey(key, false); val != nil {
		return val.(int)
	}
	return def
}

func (c *config) getForKey(key string, fail bool) any {
	parts := strings.Split(key, ".")

	data := any(c.data)
	ok := true

	for _, k := range parts {
		if data, ok = data.(map[string]any)[k]; !ok {
			if fail {
				log.Fatalf("config: key not found '%s' (%s)", key, k)
			}

			return nil
		}
	}

	return data
}
