#!/usr/bin/wpexec

-- https://gist.github.com/THS-on/a8fe22891c1008454a948e86d25315f5

local left_link_props = {
  ["link.name"] = "left-focusrite2",
  ["link.output.port"] = nil,
  ["link.input.port"] = nil,
  ["link.output.node"] = nil,
  ["link.input.node"] = nil
}
local right_link_props = {
  ["link.name"] = "right-focusrite2",
  ["link.output.port"] = nil,
  ["link.input.port"] = nil,
  ["link.output.node"] = nil,
  ["link.input.node"] = nil
}

local left_link = nil
local right_link = nil


-- metadata_om = ObjectManager {
--   Interest {
--     type = "metadata",
--     Constraint { "metadata.name", "=", "default" },
--   }
-- }

card_om = ObjectManager {
  Interest {
    type = "node",
    Constraint { "node.nick", "=", "Scarlett 6i6 USB" },
    Constraint { "media.class", "=", "Audio/Sink" },
  }
}

dsp_om = ObjectManager {
  Interest {
    type = "node",
    Constraint { "node.name", "=", "jdsp_PwJamesDspPlugin_JamesDsp" },
  }
}

card_port_om = ObjectManager {
  Interest {
    type = "port",
    Constraint { "port.alias", "#", "Scarlett 6i6 USB:playback_AUX*" }
  }
}

dsp_port_om = ObjectManager {
  Interest {
    type = "port",
    Constraint { "port.alias", "#", "JamesDsp:output_f*" }
  }
}

link_om = ObjectManager {
  Interest {
    type = "link"
  }
}

function find_port(channel_name, port_om)
  for port in port_om:iterate() do
    if port.properties["audio.channel"] == channel_name then
      return port.properties["object.id"]
    end
  end
end

function try_activate_left_link()
  if left_link ~= nil then
    if left_link.state == "init" then
      print("poke left link")
      left_link:activate(1)
    end
    print("left link is active")
    return
  end

  local count = 0
  for k, v in pairs(left_link_props) do
    count = count + 1
  end

  if count ~= 5 then
    print("Not all left link properties are set")
    return
  end

  for l in link_om:iterate {
    Constraint { "link.input.node", "=", left_link_props["link.input.node"] },
    Constraint { "link.input.port", "=", left_link_props["link.input.port"] }
  } do
    print("removing old left link")
    l:request_destroy()
  end

  print("Setup Left Link")
  left_link = Link("link-factory", left_link_props)
  left_link:activate(1)
end

function try_activate_right_link()
  if right_link ~= nil then
    if right_link.state == "init" then
      print("poke right link")
      right_link:activate(1)
    end
    print("right link is active")
    return
  end

  local count = 0
  for k, v in pairs(right_link_props) do
    count = count + 1
  end

  if count ~= 5 then
    print("Not all right link properties are set")
    return
  end

  for l in link_om:iterate {
    Constraint { "link.input.node", "=", right_link_props["link.input.node"] },
    Constraint { "link.input.port", "=", right_link_props["link.input.port"] }
  } do
    print("removing old right link")
    l:request_destroy()
  end

  print("Setup Right Link")
  right_link = Link("link-factory", right_link_props)
  right_link:activate(1)
end

function deactivate_left_link()
  if left_link == nil then
    return
  end

  left_link:request_destroy()
  left_link = nil
  left_link_props["link.output.port"] = nil
  left_link_props["link.output.node"] = nil
end

function deactivate_right_link()
  if right_link == nil then
    return
  end

  right_link:request_destroy()
  right_link = nil
  right_link_props["link.output.port"] = nil
  right_link_props["link.output.node"] = nil
end

function setup_links()
  local card_node = card_om:lookup()
  if card_node then
    local card_object_id = card_node.properties["object.id"]
    left_link_props["link.input.node"] = card_object_id
    right_link_props["link.input.node"] = card_object_id
    left_link_props["link.input.port"] = find_port("AUX2", card_port_om)
    right_link_props["link.input.port"] = find_port("AUX3", card_port_om)
  end

  local dsp_node = dsp_om:lookup()
  if dsp_node then
    local dsp_object_id = dsp_node.properties["object.id"]
    left_link_props["link.output.node"] = dsp_object_id
    right_link_props["link.output.node"] = dsp_object_id
    left_link_props["link.output.port"] = find_port("FL", dsp_port_om)
    right_link_props["link.output.port"] = find_port("FR", dsp_port_om)
  end
end

card_port_om:connect("object-added", function(om, port)
  setup_links()
  try_activate_left_link()
  try_activate_right_link()
end)

dsp_port_om:connect("object-added", function(om, port)
  setup_links()
  try_activate_left_link()
  try_activate_right_link()
end)

card_om:connect("object-added", function(om, node)
  setup_links()
  try_activate_left_link()
  try_activate_right_link()
end)

dsp_om:connect("object-added", function(om, node)
  setup_links()
  try_activate_left_link()
  try_activate_right_link()
end)

card_om:connect("object-removed", function(om, node)
  deactivate_left_link()
  deactivate_right_link()
end)

link_om:connect("object-added", function(om, l)
  if l.properties["link.input.node"] == left_link_props["link.input.node"] then
    try_activate_left_link()
  end

  if l.properties["link.input.node"] == right_link_props["link.input.node"] then
    try_activate_right_link()
  end
end)

link_om:connect("object-removed", function(om, l)
  if (
    l.properties["link.input.port"] == left_link_props["link.input.port"]
    and l.properties["link.output.port"] == left_link_props["link.output.port"]
 ) then
    print("try to add left link again")
    left_link = nil
    try_activate_left_link()
  end

  if (
    l.properties["link.input.port"] == right_link_props["link.input.port"]
    and l.properties["link.output.port"] == right_link_props["link.output.port"]
 ) then
    print("try to add right link again")
    right_link = nil
    try_activate_right_link()
  end
end)


-- was_default = false

-- function onMetadataChange(om)
--   print("metadata changed")
--   local card_node = card_om:lookup()
--   local card_name = nil
--   if card_node then
--     card_name = card_node.properties["node.name"]
--   end

--   local metadata = om:lookup()
--   local value = metadata:find(0, "default.audio.sink")
--   local json = Json.Raw(value);
--   if json == nil or not json:is_object() then
--     return
--   end

--   local vparsed = json:parse()

--   if vparsed.name ~= card_name then
--     deactivate_left_link()
--     deactivate_right_link()
--   else
--     print("card is default")
--     if was_default then
--       try_activate_left_link()
--       try_activate_right_link()
--     end
--     was_default = true
--   end
-- end

-- metadata_om:connect("object-added", function(om)
--   onMetadataChange(om)
-- end)


-- metadata_om:activate()
card_om:activate()
dsp_om:activate()
card_port_om:activate()
dsp_port_om:activate()
link_om:activate()
