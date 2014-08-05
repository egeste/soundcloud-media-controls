(function() {
  define(['oraculum', 'oraculum/libs'], function(Oraculum) {
    'use strict';
    var _;
    _ = Oraculum.get('underscore');
    return Oraculum.defineMixin('TrackActiveTab.ExtensionMixin', {
      mixinOptions: {
        trackActiveTab: {
          urlMatcher: ''
        }
      },
      mixinitialize: function() {
        this.resolveActiveTab();
        chrome.tabs.onActivated.addListener((function(_this) {
          return function(_arg) {
            var tabId;
            tabId = _arg.tabId;
            return _this.trackActiveTab(tabId);
          };
        })(this));
        chrome.tabs.onUpdated.addListener((function(_this) {
          return function(tabId) {
            return _this.trackActiveTab(tabId);
          };
        })(this));
        return chrome.tabs.onRemoved.addListener((function(_this) {
          return function(tabId) {
            if (_this.activeTabId === tabId) {
              delete _this.activeTabId;
            }
            return _this.resolveActiveTab();
          };
        })(this));
      },
      trackActiveTab: function(tabId) {
        var regexMatcher, urlMatcher;
        urlMatcher = this.mixinOptions.trackActiveTab.urlMatcher;
        regexMatcher = urlMatcher.replace('*', '.*');
        return chrome.tabs.get(tabId, (function(_this) {
          return function(_arg) {
            var id, url;
            id = _arg.id, url = _arg.url;
            if (RegExp("" + regexMatcher, "i").test(url)) {
              return _this.activeTabId = id;
            } else {
              return _this.resolveActiveTab();
            }
          };
        })(this));
      },
      resolveActiveTab: function(callback) {
        var urlMatcher;
        urlMatcher = this.mixinOptions.trackActiveTab.urlMatcher;
        chrome.tabs.query({
          url: urlMatcher
        }, (function(_this) {
          return function(tabs) {
            if (!tabs) {
              return;
            }
            _.each(tabs, function(tab) {
              if (tab.active) {
                return _this.activeTabId = tab.id;
              }
              if (tab.selected) {
                return _this.activeTabId = tab.id;
              }
              if (tab.highlighted) {
                return _this.activeTabId = tab.id;
              }
            });
            _this.activeTabId = tabs[0].id;
            if (callback) {
              return callback(_this.activeTabId);
            }
          };
        })(this));
      }
    });
  });

}).call(this);
