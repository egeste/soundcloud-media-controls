require [
  'oraculum'
  'oraculum/libs'
], (Oraculum) ->
  'use strict'

  $ = Oraculum.get 'jQuery'
  $ -> require [
    'application/layout'
    'application/routes'
    'oraculum/application/index'
  ], -> Oraculum.get 'Application',
    layout: 'Popup.Layout'
    routes: Oraculum.get 'routes'
