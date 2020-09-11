format = '%A %d/%m/%y\n%H:%M'

command: "date +\"#{format}\""

# the refresh frequency in milliseconds
refreshFrequency: 10000

render: (output) -> """
  <div id='simpleClock'>#{output}</div>
"""

update: (output) ->
  data = output.split('\n')

  html = data[1]
  html += '<div class="date">'
  html += data[0]
  html += '</div>'

  $(simpleClock).html(html)

style: (->
  fontSize = '4em'
  bottom = '15px'
  right = '15px'

  return """
    color: #FFFFFF
    font-family: Fira Sans
    right: #{right}
    bottom: #{bottom}
    text-transform: lowercase
    text-shadow: 0 2px 0px rgba(#000, .7)

    #simpleClock
      font-size: #{fontSize}
      font-weight: 100
      text-align: right

    #simpleClock .date
      font-size: .5em
  """
)()
