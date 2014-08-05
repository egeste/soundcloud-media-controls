(function() {
  define(['oraculum'], function(Oraculum) {
    'use strict';
    var accentColor, brandColor;
    brandColor = '#f30';
    accentColor = '#f80';
    return Oraculum.extend('View', 'BrowserAction.View', {
      tagName: 'canvas',
      attributes: {
        width: 19,
        height: 19
      },
      initialize: function() {
        return chrome.runtime.onMessageExternal.addListener((function(_this) {
          return function(_arg) {
            var event;
            event = _arg.event;
            switch (event) {
              case 'audio:play':
                return _this.renderPauseIcon();
              case 'audio:pause':
                return _this.renderPlayIcon();
            }
          };
        })(this));
      },
      _clear: function() {
        this.el.getContext('2d').clearRect(0, 0, 19, 19);
        return this;
      },
      _drawCircle: function(fill, stroke) {
        var context;
        if (fill == null) {
          fill = accentColor;
        }
        if (stroke == null) {
          stroke = brandColor;
        }
        context = this.el.getContext('2d');
        context.beginPath();
        context.arc(9.5, 9.5, 8.5, 0, 2 * Math.PI);
        context.strokeStyle = stroke;
        context.lineWidth = 1;
        context.stroke();
        context.fillStyle = fill;
        context.fill();
        context.closePath();
        return this;
      },
      _drawPlayIcon: function(fill, stroke) {
        var context;
        if (fill == null) {
          fill = '#fff';
        }
        if (stroke == null) {
          stroke = brandColor;
        }
        context = this.el.getContext('2d');
        context.beginPath();
        context.moveTo(7.125, 4.75);
        context.lineTo(14, 9.5);
        context.lineTo(7.125, 14);
        context.lineTo(9, 9.5);
        context.lineTo(7.125, 4.75);
        context.strokeStyle = stroke;
        context.lineWidth = 1;
        context.stroke();
        context.fillStyle = fill;
        context.fill();
        context.closePath();
        return this;
      },
      _drawPauseIcon: function(fill, stroke) {
        var context;
        if (fill == null) {
          fill = '#fff';
        }
        if (stroke == null) {
          stroke = brandColor;
        }
        context = this.el.getContext('2d');
        context.beginPath();
        context.rect(6.0625, 4.75, 2.375, 9.5);
        context.rect(10.5625, 4.75, 2.375, 9.5);
        context.strokeStyle = stroke;
        context.lineWidth = 1;
        context.stroke();
        context.fillStyle = fill;
        context.fill();
        context.closePath();
        return this;
      },
      render: function() {
        chrome.browserAction.setIcon({
          imageData: this.el.getContext('2d').getImageData(0, 0, 19, 19)
        });
        return this;
      },
      renderPlayIcon: function() {
        return this._clear()._drawCircle()._drawPlayIcon().render();
      },
      renderPauseIcon: function() {
        return this._clear()._drawCircle()._drawPauseIcon().render();
      }
    }, {
      singleton: true
    });
  });

}).call(this);
