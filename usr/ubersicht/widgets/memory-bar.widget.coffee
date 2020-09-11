command: "memory_pressure && sysctl -n hw.memsize && top -R -n 0 -l 1"

refreshFrequency: 5000

style: """
// Change bar height
bar-height = 3px

// Align contents left or right
widget-align = left

// Position this where you want
bottom 15px
left 15px

// Statistics text settings
color #fff
font-family Fira Sans
font-size 1.1em
text-shadow: 0 2px 0px rgba(#000, .7)

.container
  width: 500px
  text-align: widget-align
  position: relative
  clear: both

.container.cpu
  margin-bottom: 10px

.widget-title
  text-align: widget-align
  margin-bottom: 5px

.stats-container
  margin-bottom 10px
  border-collapse collapse

table
  font-weight: 300
  color: rgba(#fff, .9)
  text-align: widget-align

.cpu td.stat, td.label
  width: 20%

.memory td.stat, td.label
  width: 20%

td.stat-load, td.label-load
  width: 40%

.widget-title
  font-size: .6em
  font-weight: bold
  text-transform: lowercase

.label
  padding-top: 5px
  font-size .7em
  font-weight bold
  text-transform: lowercase

.bar-container
  width: 100%
  height: bar-height
  border-radius: bar-height
  float: widget-align
  clear: both
  background: rgba(#fff, .5)
  position: absolute
  margin-bottom: 5px

.bar
  height: bar-height
  float: widget-align
  transition: width .2s ease-in-out

.bar:first-child
  if widget-align == left
    border-radius: bar-height 0 0 bar-height
  else
    border-radius: 0 bar-height bar-height 0

.bar:last-child
  if widget-align == right
    border-radius: bar-height 0 0 bar-height
  else
    border-radius: 0 bar-height bar-height 0

.bar-inactive
  background: rgba(#0bf, .5)

.bar-active
  background: rgba(#fc0, .5)

.bar-wired
  background: rgba(#de3163, .5)

.bar-inactive
  background: rgba(#0bf, .5)

.bar-sys
  background: rgba(#fc0, .5)

.bar-user
  background: rgba(#c00, .5)
"""


render: -> """
<div class="container cpu">
  <div class="widget-title">CPU</div>
  <table class="stats-container" width="100%">
    <tr>
      <td class="stat stat-user"><span class="user"></span></td>
      <td class="stat stat-sys"><span class="sys"></span></td>
      <td class="stat stat-idle"><span class="idle"></span></td>
      <td class="stat stat-load"><span class="load"></span></td>
    </tr>
    <tr>
      <td class="label label-user">user</td>
      <td class="label label-sys">sys</td>
      <td class="label label-idle">idle</td>
      <td class="label label-load">load</td>
    </tr>
  </table>
</div>
<div class="container memory">
  <div class="widget-title">Memory</div>
  <table class="stats-container" width="100%">
    <tr>
      <td class="stat"><span class="wired"></span></td>
      <td class="stat"><span class="active"></span></td>
      <td class="stat"><span class="inactive"></span></td>
      <td class="stat"><span class="free"></span></td>
      <td class="stat"><span class="total"></span></td>
    </tr>
    <tr>
      <td class="label">wired</td>
      <td class="label">active</td>
      <td class="label">inactive</td>
      <td class="label">free</td>
      <td class="label">total</td>
    </tr>
  </table>
  <div class="bar-container">
    <div class="bar bar-wired"></div>
    <div class="bar bar-active"></div>
    <div class="bar bar-inactive"></div>
  </div>
</div>
"""

update: (output, domEl) ->

  usage = (pages) ->
    mb = (pages * 4096) / 1024 / 1024
    usageFormat mb

  usageFormat = (mb) ->
    if mb > 1024
      gb = mb / 1024
      "#{parseFloat(gb.toFixed(2))}GB"
    else
      "#{parseFloat(mb.toFixed())}MB"

  updateMemStat = (sel, usedPages, totalBytes) ->
    usedBytes = usedPages * 4096
    percent = (usedBytes / totalBytes * 100).toFixed(1) + "%"
    $(domEl).find(".#{sel}").text usage(usedPages)
    $(domEl).find(".bar-#{sel}").css "width", percent


  updateCpuVal = (sel, val) ->
    $(domEl).find(".#{sel}").text val

  updateCpuStat = (sel, usage) ->
    percent = usage + "%"
    $(domEl).find(".#{sel}").text percent
    # $(domEl).find(".bar-#{sel}").css "width", percent

  lines = output.split "\n"

  freePages = lines[3].split(": ")[1]
  inactivePages = lines[13].split(": ")[1]
  activePages = lines[12].split(": ")[1]
  wiredPages = lines[16].split(": ")[1]

  totalBytes = lines[28]
  $(domEl).find(".total").text usageFormat(totalBytes / 1024 / 1024)

  updateMemStat 'free', freePages, totalBytes
  updateMemStat 'active', activePages, totalBytes
  updateMemStat 'inactive', inactivePages, totalBytes
  updateMemStat 'wired', wiredPages, totalBytes

  userRegex = /(\d+\.\d+)%\suser/
  user = userRegex.exec(lines[32])[1]

  systemRegex = /(\d+\.\d+)%\ssys/
  sys = systemRegex.exec(lines[32])[1]

  idleRegex = /(\d+\.\d+)%\sidle/
  idle = idleRegex.exec(lines[32])[1]

  loadRegex = /Load Avg: (\d+\.\d+), (\d+\.\d+), (\d+\.\d+)/
  load = loadRegex.exec(lines[31])
  loadLine = [load[1], load[2], load[3]].join(' / ')

  updateCpuStat 'user', user
  updateCpuStat 'sys', sys
  updateCpuStat 'idle', idle
  updateCpuVal 'load', loadLine
