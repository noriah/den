-- https://github.com/bennetthardwick/dotfiles/tree/master/.config/wireplumber
-- As explained on: https://bennett.dev/auto-link-pipewire-ports-wireplumber/
--
-- This script keeps my stereo-null-sink connected to whatever output I'm currently using.
-- I do this so Pulseaudio (and Wine) always sees a stereo output plus I can swap the output
-- without needing to reconnect everything.

-- Link two ports together
function link_port(output_port, input_port)
  if not input_port or not output_port then
    return nil
  end

  local link_args = {
    ["link.input.node"] = input_port.properties["node.id"],
    ["link.input.port"] = input_port.properties["object.id"],

    ["link.output.node"] = output_port.properties["node.id"],
    ["link.output.port"] = output_port.properties["object.id"],

    -- The node never got created if it didn't have this field set to something
    ["object.id"] = nil,

    -- I was running into issues when I didn't have this set
    ["object.linger"] = true,

    ["node.description"] = "Link created by auto_connect_ports"
  }

  local link = Link("link-factory", link_args)
  link:activate(1)

  return link
end

-- Automatically link ports together by their specific audio channels.
--
-- ┌──────────────────┐         ┌───────────────────┐
-- │                  │         │                   │
-- │               FL ├────────►│ AUX0              │
-- │      OUTPUT      │         │                   │
-- │               FR ├────────►│ AUX1  INPUT       │
-- │                  │         │                   │
-- └──────────────────┘         │ AUX2              │
--                              │                   │
--                              └───────────────────┘
--
-- -- Call this method inside a script in global scope
--
-- auto_connect_ports {
--
--   -- A constraint for all the required ports of the output device
--   output = Constraint { "node.name"}
--
--   -- A constraint for all the required ports of the input device
--   input = Constraint { .. }
--
--   -- A mapping of output audio channels to input audio channels
--
--   connections = {
--     ["FL"] = "AUX0"
--     ["FR"] = "AUX1"
--   }
--
-- }
--
function auto_connect_ports(args)
  local output_om = ObjectManager {
    Interest {
      type = "port",
      args["output"],
      Constraint { "port.direction", "equals", "out" }
    }
  }

  local links = {}

  local input_om = ObjectManager {
    Interest {
      type = "port",
      args["input"],
      Constraint { "port.direction", "equals", "in" }
    }
  }

  local all_links = ObjectManager {
    Interest {
      type = "link",
    }
  }

  local unless = nil

  if args["unless"] then
    unless = ObjectManager {
      Interest {
        type = "port",
        args["unless"],
        Constraint { "port.direction", "equals", "in" }
      }
    }
  end

  function _connect()
    local delete_links = unless and unless:get_n_objects() > 0

    if delete_links then
      for _i, link in pairs(links) do
        link:request_destroy()
      end

      links = {}

      return
    end

    for output_name, input_names in pairs(args.connect) do
      local input_names = input_names[1] == nil and { input_names } or input_names

      if delete_links then
      else
				-- Iterate through all the output ports with the correct channel name
        for output in output_om:iterate { Constraint { "audio.channel", "equals", output_name } } do

        	for _i, input_name in pairs(input_names) do
						-- Iterate through all the input ports with the correct channel name
        	  for input in input_om:iterate { Constraint { "audio.channel", "equals", input_name } } do
							-- Link all the nodes
        	  	local link = link_port(output, input)

        	  	if link then
        	  	  table.insert(links, link)
        	  	end
						end
        	end
				end
      end
    end
  end

  output_om:connect("object-added", _connect)
  input_om:connect("object-added", _connect)
  all_links:connect("object-added", _connect)

  output_om:activate()
  input_om:activate()
  all_links:activate()

  if unless then
    unless:connect("object-added", _connect)
    unless:connect("object-removed", _connect)
    unless:activate()
  end
end

-- main system mic
auto_connect_ports {
  output = Constraint { "port.alias", "matches", "Scarlett 18i20 USB:capture_AUX*" },
  input = Constraint { "object.path", "matches", "system_source:input_*" },
  connect = {
    ["AUX0"] = "FL",
  }
}

auto_connect_ports {
  output = Constraint { "port.alias", "matches", "Scarlett 18i20 USB:capture_AUX*" },
  input = Constraint { "object.path", "matches", "system_source:input_*" },
  connect = {
    ["AUX0"] = "FR",
  }
}

-- main system mic mono
auto_connect_ports {
  output = Constraint { "port.alias", "matches", "Scarlett 18i20 USB:capture_AUX*" },
  input = Constraint { "object.path", "matches", "system_source_mono:input_*" },
  connect = {
    ["AUX0"] = "MONO",
  }
}

-- guitar input
auto_connect_ports {
  output = Constraint { "port.alias", "matches", "Scarlett 18i20 USB:capture_AUX*" },
  input = Constraint { "object.path", "matches", "guitar_source:input_*" },
  connect = {
    ["AUX3"] = "MONO",
  }
}

-- synth input
auto_connect_ports {
  output = Constraint { "port.alias", "matches", "Scarlett 18i20 USB:capture_AUX*" },
  input = Constraint { "object.path", "matches", "synth_source:input_*" },
  connect = {
    ["AUX4"] = "FL",
    ["AUX5"] = "FR",
  }
}

-- ext input
auto_connect_ports {
  output = Constraint { "port.alias", "matches", "Scarlett 18i20 USB:capture_AUX*" },
  input = Constraint { "object.path", "matches", "ext_source:input_*" },
  connect = {
    ["AUX8"] = "AUX0",
    ["AUX9"] = "AUX1",
  }
}

-- vis input
auto_connect_ports {
  output = Constraint { "port.alias", "matches", "spotify:output_*" },
  input = Constraint { "object.path", "matches", "vis_source:input_*" },
  connect = {
    ["FL"] = "FL",
    ["FR"] = "FR",
  }
}

auto_connect_ports {
  output = Constraint { "port.alias", "matches", "Rhythmbox:output_*" },
  input = Constraint { "object.path", "matches", "vis_source:input_*" },
  connect = {
    ["FL"] = "FL",
    ["FR"] = "FR",
  }
}

-- system output
auto_connect_ports {
  output = Constraint { "object.path", "matches", "system_sink:monitor_*" },
  input = Constraint { "port.alias", "matches", "Scarlett 18i20 USB:playback_AUX*" },
  connect = {
    ["FL"] = "AUX0",
    ["FR"] = "AUX1",
  }
}

-- media output
auto_connect_ports {
  output = Constraint { "object.path", "matches", "media_sink:monitor_*" },
  input = Constraint { "port.alias", "matches", "Scarlett 18i20 USB:playback_AUX*" },
  connect = {
    ["FL"] = "AUX2",
    ["FR"] = "AUX3",
  }
}

-- voice output
auto_connect_ports {
  output = Constraint { "object.path", "matches", "voice_sink:monitor_*" },
  input = Constraint { "port.alias", "matches", "Scarlett 18i20 USB:playback_AUX*" },
  connect = {
    ["FL"] = "AUX4",
    ["FR"] = "AUX5",
  }
}

-- 6i6 output
auto_connect_ports {
  output = Constraint { "object.path", "matches", "ext_sink:monitor_*" },
  input = Constraint { "port.alias", "matches", "Scarlett 18i20 USB:playback_AUX*" },
  connect = {
    ["AUX0"] = "AUX8",
    ["AUX1"] = "AUX9",
  }
}

-- to wireless headset
-- system output
auto_connect_ports {
  output = Constraint { "object.path", "matches", "system_sink:monitor_*" },
  input = Constraint { "port.alias", "matches", "WH-1000XM4:playback_*" },
  connect = {
    ["FL"] = "FL",
    ["FR"] = "FR",
  }
}

-- media output
auto_connect_ports {
  output = Constraint { "object.path", "matches", "media_sink:monitor_*" },
  input = Constraint { "port.alias", "matches", "WH-1000XM4:playback_*" },
  connect = {
    ["FL"] = "FL",
    ["FR"] = "FR",
  }
}

-- voice output
auto_connect_ports {
  output = Constraint { "object.path", "matches", "voice_sink:monitor_*" },
  input = Constraint { "port.alias", "matches", "WH-1000XM4:playback_*" },
  connect = {
    ["FL"] = "FL",
    ["FR"] = "FR",
  }
}


