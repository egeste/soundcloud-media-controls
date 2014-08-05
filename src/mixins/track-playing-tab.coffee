define [
  'oraculum'
  'oraculum/libs'
], (Oraculum) ->
  'use strict'

  _ = Oraculum.get 'underscore'

  Oraculum.defineMixin 'TrackPlayingTab.ExtensionMixin',

    mixinOptions:
      trackPlayingTab:
        urlMatcher: ''

    mixinitialize: ->
      chrome.tabs.onUpdated.addListener @trackPlayingTab
      chrome.tabs.onRemoved.addListener @trackPlayingTab
      chrome.tabs.onActivated.addListener @trackPlayingTab
      chrome.runtime.onMessageExternal.addListener ({event}, {tab}) =>
        @trackPlayingTab tab if event is 'audio:playing'
      @trackPlayingTab()

    trackPlayingTab: (tab) ->
      return @playingTab = tab if tab
      return @playingTab if @playingTab
      urlMatcher = @mixinOptions.trackPlayingTab.urlMatcher
      chrome.tabs.query {url: urlMatcher}, (tabs) =>
        return unless tabs
        _.each tabs, (tab) =>
          return @playingTab = tab if tab.active
          return @playingTab = tab if tab.selected
          return @playingTab = tab if tab.highlighted
        @playingTab = tabs[0]
