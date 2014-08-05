define [
  'oraculum'
  'views/browser-action'
  'mixins/track-playing-tab'
  'mixins/inject-content-scripts'
], (Oraculum) ->
  'use strict'

  Oraculum.define 'Extension', (class ChromeExtension

    constructor: ->
      @__factory().get 'BrowserAction.View'
      @_addCommandListeners()

    mixinOptions:
      injectContentScripts:
        urlMatcher: '*://soundcloud.com/*'
        scripts: ['scripts/message-bus.js']
      trackPlayingTab:
        urlMatcher: '*://soundcloud.com/*'

    _addCommandListeners: ->
      chrome.commands.onCommand.addListener (command) =>
        chrome.tabs.sendMessage @playingTab.id, command if @playingTab

  ), {
    singleton: true
    mixins: [
      'TrackPlayingTab.ExtensionMixin'
      'InjectContentScripts.ExtensionMixin'
    ]
  }
