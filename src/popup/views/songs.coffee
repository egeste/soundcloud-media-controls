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
          <li><strong data-prop="model" data-prop-attr="title"/></li>
          <li>
            <small data-prop="model"
                   data-prop-attr="genre"
                   class="pull-right"
            />
            <small data-prop="model"
                   data-prop-attr="user.username"
            />
          </li>
        </ul>
      """

  }, mixins: [
    'StaticClasses.ViewMixin'
    'HTMLTemplating.ViewMixin'
    'DOMPropertyBinding.ViewMixin'
  ]

  Oraculum.extend 'View', 'Songs.View', {
    tagName: 'ul'
    className: 'list-unstyled'

    mixinOptions:
      staticClasses: ['songs-view']
      list:
        modelView: 'Song.View'

  }, {
    singleton: true
    mixins: [
      'List.ViewMixin'
      'RegionAttach.ViewMixin'
      'StaticClasses.ViewMixin'
      'AutoRender.ViewMixin'
    ]
  }
