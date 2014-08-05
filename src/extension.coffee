define [
  'oraculum'
  'oraculum/libs'
  'views/browser-action'
  'mixins/track-active-tab'
  'mixins/inject-content-scripts'
], (Oraculum) ->
  'use strict'

  _ = Oraculum.get 'underscore'

  Oraculum.define 'Extension', (class ChromeExtension

    constructor: ->
      _.bindAll this, '_sendCommand'
      @__factory().get 'BrowserAction.View'
      chrome.commands.onCommand.addListener @_sendCommand
      chrome.runtime.onMessageExternal.addListener ({event}, {tab}) =>
        if event is 'audio:play' then @trackActiveTab tab.id
        if event is 'audio:pause'
          delete @activeTabId
          @resolveActiveTab()

    mixinOptions:
      injectContentScripts:
        urlMatcher: '*://soundcloud.com/*'
        scripts: ['scripts/message-bus.js']
      trackActiveTab:
        urlMatcher: '*://soundcloud.com/*'

    _sendCommand: (command) ->
      sendCommand = (tabId) ->
        chrome.tabs.sendMessage tabId, command
      if @activeTabId
      then sendCommand @activeTabId
      else @resolveActiveTab sendCommand

  ), {
    singleton: true
    mixins: [
      'TrackActiveTab.ExtensionMixin'
      'InjectContentScripts.ExtensionMixin'
    ]
  }
