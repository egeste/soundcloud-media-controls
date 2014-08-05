define [
  'oraculum'
  'oraculum/libs'
  'views/browser-action'
  'mixins/inject-content-scripts'

  # Pull in the pop song model so we can cache everything
  '../popup/models/song'
], (Oraculum) ->
  'use strict'

  _ = Oraculum.get 'underscore'
  urlMatcher = '*://soundcloud.com/*'

  Oraculum.define 'Background', (class BackgroundPage

    constructor: ->
      @songs = @__factory().get 'Song.Collection'
      @browserAction = @__factory().get 'BrowserAction.View'
      chrome.runtime.onMessage.addListener (event, sender, callback) =>
        callback @songs.models if event is 'getSongs'
      chrome.runtime.onMessageExternal.addListener ({event}, {tab}) =>
        if event is 'audio:play' then @playingTab = tab
        if event is 'audio:pause' then delete @playingTab
      chrome.tabs.onRemoved.addListener (tabId) =>
        delete @playingTab if @playingTab?.id is tabId
      chrome.commands.onCommand.addListener (command) =>
        @getActiveTab (tab) -> chrome.tabs.sendMessage tab.id, command

    mixinOptions:
      injectContentScripts:
        urlMatcher: urlMatcher
        scripts: ['scripts/message-bus.js']

    getActiveTab: (callback) ->
      return callback @playingTab if @playingTab
      chrome.tabs.query {url: urlMatcher}, (tabs) =>
        return callback tab if tab.active for tab in tabs
        return callback tabs[0] if tabs[0]

  ), {
    singleton: true
    mixins: ['InjectContentScripts.BackgroundMixin']
  }
