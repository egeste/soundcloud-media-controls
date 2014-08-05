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
      _.bindAll this, '_handleUpdate'
      urlMatcher = @mixinOptions.injectContentScripts.urlMatcher
      chrome.tabs.onUpdated.addListener @_handleUpdate
      chrome.tabs.query {url: urlMatcher}, (tabs) =>
        _.each tabs, (tab) => @injectContentScripts tab

    _handleUpdate: (id, update, tab) ->
      return unless update.status is 'complete'
      @injectContentScripts tab

    injectContentScripts: (tab) ->
      urlMatcher = @mixinOptions.injectContentScripts.urlMatcher
      regexMatcher = urlMatcher.replace '*', '.*'
      return unless tab
      return unless ///#{regexMatcher}///i.test tab.url
      scripts = @mixinOptions.injectContentScripts.scripts
      _.each scripts, (file) -> chrome.tabs.executeScript tab.id, {file}
