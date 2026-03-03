package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"os/signal"
	"strings"
	"time"

	"github.com/noriah/den/src/polyden"
	_ "github.com/noriah/den/src/polyden/modules"

	"github.com/integrii/flaggy"
)

const (
	AppName = "polyden"
	AppDesc = "polybar tool"
)

var version = "whatever"

type config struct {
	command     string
	interval    float32
	configPath  string
	listModules bool
}

func defaultConfig() config {
	return config{
		configPath: "$HOME/den/etc/polybar/config.yml",
	}
}

func main() {
	cfg := defaultConfig()
	doFlags(&cfg)

	if cfg.listModules {
		listModules()
		return
	}

	config := polyden.NewConfig()

	chk(config.Load(cfg.configPath), "error in load config")

	module := polyden.GetModule(cfg.command)

	if module == nil {
		panic("can't find module")
	}

	if cfg.interval == 0.0 {
		chk(module.Draw(config), "error in draw")
		return
	}

	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt)
	defer cancel()

	timer := time.NewTicker(time.Duration(cfg.interval * float32(time.Second)))

	for {
		chk(module.Draw(config), "error in draw")
		select {
		case <-timer.C:
		case <-ctx.Done():
			return
		}
	}
}

func listModules() {
	modules := polyden.ListModules()
	for _, mod := range modules {
		fmt.Printf("- %s, %s\n", mod.Id(), strings.Join(mod.Aliases(), ", "))
	}
}

func doFlags(cfg *config) bool {

	parser := flaggy.NewParser(AppName)
	parser.Description = AppDesc
	// parser.AdditionalHelpPrepend = AppSite
	parser.Version = version

	parser.AddPositionalValue(&cfg.command, "module", 1, false, "module to run")
	parser.String(&cfg.configPath, "c", "config", "path to config. env variables allowed")
	parser.Float32(&cfg.interval, "n", "interval", "draw interval")
	parser.Bool(&cfg.listModules, "l", "list-modules", "list all modules")

	chk(parser.Parse(), "failed to parse arguments")

	if !cfg.listModules {
		if len(cfg.command) == 0 {
			parser.ShowHelpWithMessage("missing required parameter [module]")
			os.Exit(2)
		}
	}

	return false
}

func chk(err error, wrap string) {
	if err != nil {
		log.Fatalln(wrap+": ", err)
	}
}
