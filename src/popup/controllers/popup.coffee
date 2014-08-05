define [
  'oraculum'
  'oraculum/application/controller'

  'models/song'
  'views/songs'
], (Oraculum) ->
  'use strict'

  Oraculum.extend 'Controller', 'Popup.Controller', {

    index: ->
      @reuse 'songs-view', 'Songs.View',
        region: 'history'
        collection: 'Song.Collection'

  }, inheritMixins: true
