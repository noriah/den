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
}

type config struct {
	filePath string
	data     map[string]interface{}
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
	return c.getForKey(key).(string)
}

func (c *config) GetInt(key string) int {
	return c.getForKey(key).(int)
}

func (c *config) getForKey(key string) interface{} {
	parts := strings.Split(key, ".")

	data := interface{}(c.data)
	ok := true

	for _, k := range parts {
		if data, ok = data.(map[string]interface{})[k]; !ok {
			log.Fatalf("config: key not found '%s' (%s)", key, k)
		}
	}

	return data
}
