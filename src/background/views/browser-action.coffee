define [
  'oraculum'
], (Oraculum) ->
  'use strict'

  brandColor = '#f30'
  accentColor = '#f80'

  Oraculum.extend 'View', 'BrowserAction.View', {
    tagName: 'canvas'
    attributes:
      width: 19
      height: 19

    initialize: ->
      chrome.runtime.onMessageExternal.addListener ({event}) =>
        switch event
          when 'audio:play' then @renderPauseIcon()
          when 'audio:pause' then @renderPlayIcon()

    _clear: ->
      @el.getContext('2d').clearRect(0, 0, 19, 19)
      return this

    _drawCircle: (fill=accentColor, stroke=brandColor) ->
      context = @el.getContext '2d'
      context.beginPath()
      context.arc(9.5, 9.5, 8.5, 0, 2 * Math.PI)
      context.strokeStyle = stroke
      context.lineWidth = 1
      context.stroke()
      context.fillStyle = fill
      context.fill()
      context.closePath()
      return this

    _drawPlayIcon: (fill='#fff', stroke=brandColor) ->
      context = @el.getContext '2d'
      context.beginPath()
      context.moveTo(7.125, 4.75)
      context.lineTo(14, 9.5)
      context.lineTo(7.125, 14)
      context.lineTo(9, 9.5)
      context.lineTo(7.125, 4.75)
      context.strokeStyle = stroke
      context.lineWidth = 1
      context.stroke()
      context.fillStyle = fill
      context.fill()
      context.closePath()
      return this

    _drawPauseIcon: (fill='#fff', stroke=brandColor) ->
      context = @el.getContext '2d'
      context.beginPath()
      context.rect(6.0625, 4.75, 2.375, 9.5)
      context.rect(10.5625, 4.75, 2.375, 9.5)
      context.strokeStyle = stroke
      context.lineWidth = 1
      context.stroke()
      context.fillStyle = fill
      context.fill()
      context.closePath()
      return this

    render: ->
      chrome.browserAction.setIcon
        imageData: @el.getContext('2d').getImageData(0, 0, 19, 19)
      return this

    renderPlayIcon: ->
      return @_clear()._drawCircle()._drawPlayIcon().render()

    renderPauseIcon: ->
      return @_clear()._drawCircle()._drawPauseIcon().render()

  }, singleton: true
