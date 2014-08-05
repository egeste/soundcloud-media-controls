define [
  'oraculum'
  'oraculum/libs'
], (Oraculum) ->
  'use strict'

  _ = Oraculum.get 'underscore'

  Oraculum.defineMixin 'TrackActiveTab.ExtensionMixin',

    mixinOptions:
      trackActiveTab:
        urlMatcher: ''

    mixinitialize: ->
      @resolveActiveTab()
      chrome.tabs.onActivated.addListener ({tabId}) => @trackActiveTab tabId
      chrome.tabs.onUpdated.addListener (tabId) => @trackActiveTab tabId
      chrome.tabs.onRemoved.addListener (tabId) =>
        delete @activeTabId if @activeTabId is tabId
        @resolveActiveTab()

    trackActiveTab: (tabId) ->
      urlMatcher = @mixinOptions.trackActiveTab.urlMatcher
      regexMatcher = urlMatcher.replace '*', '.*'
      chrome.tabs.get tabId, ({id, url}) =>
        if ///#{regexMatcher}///i.test url
        then @activeTabId = id
        else @resolveActiveTab()

    resolveActiveTab: (callback) ->
      urlMatcher = @mixinOptions.trackActiveTab.urlMatcher
      chrome.tabs.query {url: urlMatcher}, (tabs) =>
        return unless tabs
        _.each tabs, (tab) =>
          return @activeTabId = tab.id if tab.active
          return @activeTabId = tab.id if tab.selected
          return @activeTabId = tab.id if tab.highlighted
        @activeTabId = tabs[0].id
        callback @activeTabId if callback
      return # silence
