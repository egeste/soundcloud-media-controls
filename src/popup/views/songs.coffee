define [
  'oraculum'
  'oraculum/views/mixins/list'
  'oraculum/views/mixins/auto-render'
  'oraculum/views/mixins/region-attach'
  'oraculum/views/mixins/static-classes'
  'oraculum/views/mixins/html-templating'
  'oraculum/views/mixins/dom-property-binding'
], (Oraculum) ->
  'use strict'

  Oraculum.extend 'View', 'Song.View', {
    tagName: 'li'
    className: 'clearfix'

    mixinOptions:
      staticClasses: ['song-view']
      # TODO: i18n
      template: -> """
        <img class="col-xs-2" src="#{@model.get 'artwork_url'}"/>
        <ul class="col-xs-10 list-unstyled">
          <li data-prop="model" data-prop-attr="title"/>
        </ul>
      """

  }, mixins: [
    'StaticClasses.ViewMixin'
    'HTMLTemplating.ViewMixin'
    'DOMPropertyBinding.ViewMixin'
  ]

  Oraculum.extend 'View', 'Songs.View', {

    mixinOptions:
      staticClasses: ['songs-view']
      list:
        modelView: 'Song.View'
        listSelector: '.song-list'
      # TODO: i18n
      template: '''
        <h1>Song History</h1>
        <ul class="song-list list-unstyled"/>
      '''

  }, {
    singleton: true
    mixins: [
      'List.ViewMixin'
      'RegionAttach.ViewMixin'
      'StaticClasses.ViewMixin'
      'HTMLTemplating.ViewMixin'
      'AutoRender.ViewMixin'
    ]
  }
