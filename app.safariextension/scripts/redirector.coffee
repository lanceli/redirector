'use strict'

getTarget = (element) ->
  if element.nodeName is 'LINK' and element.type is 'text/css'
    target = 'style'
  else
    target = element.nodeName.toLowerCase()
  return target

document.addEventListener 'beforeload', (event) ->
  element = event.target
  target = getTarget(element)
  response = safari.self.tab.canLoad(event, {
    name: 'checkUrl',
    target: target
    url: event.url
  })
  if response.type is 'block'
    console.error(event.url + ' is blocked')
    event.preventDefault()
  if response.type is 'redirect'
    msg = event.url + ' is redirected to ' + response.to
    if response.code isnt 200
      msg += ' failed'
      console.error(msg)
    else
      msg += ' succesful'
      console.warn(msg)
    if response.code isnt 200
      return false

    switch target
      when 'style'
        element.href = element.href.replace(response.from, response.to)
        event.preventDefault()
      when 'script'
        script = document.createElement('script')
        script.innerHTML = response.script
        document.head.insertBefore(script, document.head.firstChild)
        event.preventDefault()
      else
        if element.src
            setTimeout () ->
              element.src = element.src.replace(response.from, response.to)
              return
            , 0
            event.preventDefault()
  return
, true
