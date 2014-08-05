define [
  'oraculum'
  'oraculum/models/mixins/auto-fetch'
], (Oraculum) ->
  'use strict'

  Oraculum.extend 'Collection', 'Song.Collection', {

    comparator: (model) ->
      return -1 * model.get 'lastPlayed'

    initialize: ->
      chrome.runtime.onMessageExternal.addListener ({event, data}, {tab}) =>
        return unless event is 'audio:play'
        @add _.extend {
          lastPlayed: Date.now()
        }, data.sound

    sync: (method, model, options) ->
      chrome.runtime.sendMessage 'getSongs', (response) ->
        options.success response if response

  }, {
    singleton: true
    mixins: ['AutoFetch.ModelMixin']
  }
