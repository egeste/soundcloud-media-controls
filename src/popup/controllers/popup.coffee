define [
  'oraculum'
  'oraculum/application/controller'

  'views/songs'
  'shared/models/song'
], (Oraculum) ->
  'use strict'

  Oraculum.extend 'Controller', 'Popup.Controller', {

    index: ->
      @reuse 'songs-view', 'Songs.View',
        region: 'history'
        collection: 'Song.Collection'

  }, inheritMixins: true
