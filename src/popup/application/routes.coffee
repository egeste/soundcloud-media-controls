define [
  'oraculum'
  'controllers/popup'
], (Oraculum) ->
  'use strict'

  Oraculum.define 'routes', -> (match) ->
    match '*url', 'Popup.Controller#index'
