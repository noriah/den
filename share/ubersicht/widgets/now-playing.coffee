command: '/usr/bin/env bash "$HOME/bin/shpotify" status 2>/dev/null'

# the refresh frequency in milliseconds
refreshFrequency: 5000

style: """
widget-align = left

color: rgba(#fff, .9)
font-family: Fira Sans
font-size: 1em
left: 615px
bottom: 10px
text-shadow: 0 2px 0px rgba(#000, .7)

.container
  text-align: widget-align
  position: relative
  clear: both

.widget-title
  color: #fff
  font-size: .6em
  font-weight: bold
  text-transform: lowercase
  text-align: widget-align

.stats-container
  border-collapse collapse
  font-weight: 300
  text-align: widget-align

.label
  font-size: 0.8em
  font-weight: 500
  text-transform: lowercase
  padding-top: 5px
  padding-bottom: 5px

.stat
  font-size: 1em
  font-weight: 300
  float: center

"""

render: -> """
<div class="container">
  <div class="widget-title">music</div>
  <div class="label"><span>title</span></div>
  <div class="stat"><span class="track"></span></div>
  <div class="label"><span>by</span></div>
  <div class="stat"><span class="artist"></span></div>
</div>
"""


update: (output, domEl) ->

  updateStat = (sel, val) ->
    $(domEl).find(".#{sel}").text val

  data = output.split('\n')

  updateStat 'track', data[3].split(': ')[1]
  updateStat 'artist', data[1].split(': ')[1]
