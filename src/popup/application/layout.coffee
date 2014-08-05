define [
  'oraculum'
  'oraculum/views/mixins/layout'
], (Oraculum) ->
  'use strict'

  Oraculum.extend 'View', 'Popup.Layout', {
    el: document.body

    mixinOptions:
      regions:
        'history': '#history'
        'controls': '#controls'

  }, {
    singleton: true
    mixins: ['Layout.ViewMixin']
  }
