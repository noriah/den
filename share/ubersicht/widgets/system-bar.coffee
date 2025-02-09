command: "memory_pressure && sysctl -n hw.memsize && top -R -n 0 -l 1"

refreshFrequency: 5000

style: """
bar-height = 3px

widget-align = left

bottom 15px
left 15px

color #fff
font-family Fira Sans
font-size 1em
text-shadow: 0 2px 0px rgba(#000, .7)

.container
  width: 500px
  text-align: widget-align
  position: relative
  clear: both

.widget-title
  margin-bottom: 5px
  font-size: .6em
  font-weight: bold
  text-transform: lowercase
  text-align: widget-align

.stats-container
  border-collapse collapse
  font-weight: 300
  color: rgba(#fff, .9)
  text-align: widget-align

.stats-container.cpu
  margin-bottom 10px

.cpu td.stat, .cpu td.label
  width: 20%

.cpu td.stat-load, .cpu td.label-load
  width: 40%

.memory td.stat, .memory td.label
  width: 20%

.label
  padding-top: 5px
  font-size: .7em
  font-weight: 500
  text-transform: lowercase

"""


render: -> """
<div class="container">
  <div class="widget-title">CPU / Memory</div>
  <table class="stats-container cpu" width="100%">
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
  <table class="stats-container memory" width="100%">
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

  updateStat = (sel, val) ->
    $(domEl).find(".#{sel}").text val

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

  userRegex = /(\d+\.\d+%)\suser/
  user = userRegex.exec(lines[32])[1]

  systemRegex = /(\d+\.\d+%)\ssys/
  sys = systemRegex.exec(lines[32])[1]

  idleRegex = /(\d+\.\d+%)\sidle/
  idle = idleRegex.exec(lines[32])[1]

  loadRegex = /Load Avg: (\d+\.\d+), (\d+\.\d+), (\d+\.\d+)/
  loadRet = loadRegex.exec(lines[31])
  load = [loadRet[1], loadRet[2], loadRet[3]].join(' / ')

  updateStat 'user', user
  updateStat 'sys', sys
  updateStat 'idle', idle
  updateStat 'load', load
