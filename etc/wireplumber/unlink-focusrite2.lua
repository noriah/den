#!/usr/bin/env wpexec

link_om = ObjectManager {
  Interest {
    type = "link",
    Constraint { "link.name", "#", "*-focusrite2" }
  }
}

link_om:activate()

for l in link_om:iterate() do
  print(l.properties["link.name"])
  l:request_destroy()
end
