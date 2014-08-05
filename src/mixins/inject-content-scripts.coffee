define [
  'oraculum'
  'oraculum/libs'
], (Oraculum) ->
  'use strict'

  _ = Oraculum.get 'underscore'

  Oraculum.defineMixin 'InjectContentScripts.ExtensionMixin',

    mixinOptions:
      injectContentScripts:
        scripts: []
        urlMatcher: ''

    mixinitialize: ->
      # Inject our scripts into all new tabs that match our urlMatcher
      chrome.tabs.onUpdated.addListener (tabId, {status}) =>
        @injectContentScripts tabId if status is 'complete'

      # Inject our scripts in all existing tabs that match our urlMatcher
      urlMatcher = @mixinOptions.injectContentScripts.urlMatcher
      chrome.tabs.query {url: urlMatcher}, (tabs) =>
        _.each tabs, (tab) => @injectContentScripts tab.id

    injectContentScripts: (tabId) ->
      urlMatcher = @mixinOptions.injectContentScripts.urlMatcher
      regexMatcher = urlMatcher.replace '*', '.*'
      chrome.tabs.get tabId, ({id, url}) =>
        return unless ///#{regexMatcher}///i.test url
        scripts = @mixinOptions.injectContentScripts.scripts
        _.each scripts, (file) -> chrome.tabs.executeScript id, {file}
