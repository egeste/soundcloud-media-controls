(function() {
  define(['oraculum', 'oraculum/libs', 'views/browser-action', 'mixins/track-active-tab', 'mixins/inject-content-scripts'], function(Oraculum) {
    'use strict';
    var ChromeExtension, _;
    _ = Oraculum.get('underscore');
    return Oraculum.define('Extension', (ChromeExtension = (function() {
      function ChromeExtension() {
        _.bindAll(this, '_sendCommand');
        this.__factory().get('BrowserAction.View');
        chrome.commands.onCommand.addListener(this._sendCommand);
        chrome.runtime.onMessageExternal.addListener((function(_this) {
          return function(_arg, _arg1) {
            var event, tab;
            event = _arg.event;
            tab = _arg1.tab;
            if (event === 'audio:play') {
              _this.trackActiveTab(tab.id);
            }
            if (event === 'audio:pause') {
              delete _this.activeTabId;
              return _this.resolveActiveTab();
            }
          };
        })(this));
      }

      ChromeExtension.prototype.mixinOptions = {
        injectContentScripts: {
          urlMatcher: '*://soundcloud.com/*',
          scripts: ['scripts/message-bus.js']
        },
        trackActiveTab: {
          urlMatcher: '*://soundcloud.com/*'
        }
      };

      ChromeExtension.prototype._sendCommand = function(command) {
        var sendCommand;
        sendCommand = function(tabId) {
          return chrome.tabs.sendMessage(tabId, command);
        };
        if (this.activeTabId) {
          return sendCommand(this.activeTabId);
        } else {
          return this.resolveActiveTab(sendCommand);
        }
      };

      return ChromeExtension;

    })()), {
      singleton: true,
      mixins: ['TrackActiveTab.ExtensionMixin', 'InjectContentScripts.ExtensionMixin']
    });
  });

}).call(this);
