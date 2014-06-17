'use strict'

console.log('%cBINGO!!!\nlyfuture@gmail.com', 'color:Orange');

defaultRules = 'from_url,to_url\nfrom_url,to_url,disabled_rule\nblock_url\nblock_url,,disabled_rule'
document.addEventListener 'DOMContentLoaded', () ->
  $rules = document.getElementById('rules')
  $rules.focus()
  $rules.innerText = localStorage.getItem('rules_text') || defaultRules
  $rules.onkeyup = (e) ->
    rules = []
    this.innerText.split('\n').forEach (v, i) ->
      if v.trim() isnt ''
        rules.push(v.split(','))
      return
    localStorage.setItem('rules_json', JSON.stringify(rules))
    localStorage.setItem('rules_text', this.innerText)
    if safari
      safari.self.tab.dispatchMessage('saveRules', {
        json: JSON.stringify(rules),
        text: this.innerText
      })
    return
  return
