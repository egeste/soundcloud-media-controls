(function() {
  define(['oraculum', 'views/browser-action', 'mixins/track-playing-tab', 'mixins/inject-content-scripts'], function(Oraculum) {
    'use strict';
    var ChromeExtension;
    return Oraculum.define('Extension', (ChromeExtension = (function() {
      function ChromeExtension() {
        this.__factory().get('BrowserAction.View');
        this._addCommandListeners();
      }

      ChromeExtension.prototype.mixinOptions = {
        injectContentScripts: {
          urlMatcher: '*://soundcloud.com/*',
          scripts: ['scripts/message-bus.js']
        },
        trackPlayingTab: {
          urlMatcher: '*://soundcloud.com/*'
        }
      };

      ChromeExtension.prototype._addCommandListeners = function() {
        return chrome.commands.onCommand.addListener((function(_this) {
          return function(command) {
            if (_this.playingTab) {
              return chrome.tabs.sendMessage(_this.playingTab.id, command);
            }
          };
        })(this));
      };

      return ChromeExtension;

    })()), {
      singleton: true,
      mixins: ['TrackPlayingTab.ExtensionMixin', 'InjectContentScripts.ExtensionMixin']
    });
  });

}).call(this);
