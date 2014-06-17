'use strict'

# extension settings change event handler
handleChangeEvent = (event) ->
  if event.key is 'options' and event.newValue is true
    safari.extension.settings.options = false
    openOptionsPage()
  return

# open tab
openTab = (url) ->
  if safari.application.activeBrowserWindow
    tab = safari.application.activeBrowserWindow.openTab('foreground')
  else
    tab = safari.application.openBrowserWindow().activeTab
  tab.url = url
  return

# open tab
openOptionsPage = () ->
  openTab(safari.extension.baseURI + 'options.html')
  return

# check if first install
version = localStorage.getItem('version')
if !version
  openOptionsPage()
localStorage.setItem('version', safari.extension.bundleVersion)


# get script by ajax or local storage
getScript = (url) ->
  data = localStorage.getItem(url) || ''
  code = 200
  if !data
    try
      req = new XMLHttpRequest()
      req.open('get', url, false)
      req.send()
      contentType = req.getResponseHeader('Content-Type') || ''
      if req.status is 200 && contentType.indexOf('script') isnt -1
        data = req.responseText
        localStorage.setItem(url, data)
      else
        code = if req.status is 200 then 0 else req.status
    catch err
      code = err.code
      console.error(err)
  {
    code: code
    data: data
  }

# check url
checkUrl = (event) ->
  message = event.message
  rules = JSON.parse(localStorage.getItem('rules_json'))
  url  = message.url
  rules.every (v, i) ->
    try
      re = new RegExp(v[0])
      isMatch = re.test(url)
    catch
      console.error(_error)

    if isMatch || url.indexOf(v[0]) isnt -1
      switch v.length
        # redirect rule
        when 2
          newUrl = url.replace(v[0], v[1])
          if /^\/\//.test(newUrl)
            newUrl = 'http:' + newUrl
          if message.target is 'script'
            response = getScript(newUrl)
            event.message = {
              type: 'redirect',
              code: response.code
              from: url,
              to: newUrl,
              script: response.data
            }
            return false
          else
            event.message = {
              type: 'redirect',
              code: 200
              from: url,
              to: newUrl
            }
            return false
        # block rule
        when 1
          event.message = {
            code: 200,
            type: 'block',
            url: url
          }
          return false
        # disabled rule
        else
          event.message = {
            url: url,
            type: 'donothing',
            code: 0
          }
          return false
    else
      # no match
    return true
  return

# safari message event handler
respondToMessage = (event) ->
  message = event.message
  switch event.name
    when 'getRules'
      event.target.page.dispatchMessage('rules', localStorage.getItem('rules_json'))
    when 'saveRules'
      localStorage.setItem('rules_json', message.json)
      localStorage.setItem('rules_text', message.text)
    when 'canLoad'
      if message.name is 'checkUrl'
        checkUrl(event)
  return

# message event listener
safari.application.addEventListener('message', respondToMessage, false)

# settings change event listener
safari.extension.settings.addEventListener('change', handleChangeEvent, false)
