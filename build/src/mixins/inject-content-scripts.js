(function() {
  define(['oraculum', 'oraculum/libs'], function(Oraculum) {
    'use strict';
    var _;
    _ = Oraculum.get('underscore');
    return Oraculum.defineMixin('InjectContentScripts.ExtensionMixin', {
      mixinOptions: {
        injectContentScripts: {
          scripts: [],
          urlMatcher: ''
        }
      },
      mixinitialize: function() {
        var urlMatcher;
        chrome.tabs.onUpdated.addListener((function(_this) {
          return function(tabId, _arg) {
            var status;
            status = _arg.status;
            if (status === 'complete') {
              return _this.injectContentScripts(tabId);
            }
          };
        })(this));
        urlMatcher = this.mixinOptions.injectContentScripts.urlMatcher;
        return chrome.tabs.query({
          url: urlMatcher
        }, (function(_this) {
          return function(tabs) {
            return _.each(tabs, function(tab) {
              return _this.injectContentScripts(tab.id);
            });
          };
        })(this));
      },
      injectContentScripts: function(tabId) {
        var regexMatcher, urlMatcher;
        urlMatcher = this.mixinOptions.injectContentScripts.urlMatcher;
        regexMatcher = urlMatcher.replace('*', '.*');
        return chrome.tabs.get(tabId, (function(_this) {
          return function(_arg) {
            var id, scripts, url;
            id = _arg.id, url = _arg.url;
            if (!RegExp("" + regexMatcher, "i").test(url)) {
              return;
            }
            scripts = _this.mixinOptions.injectContentScripts.scripts;
            return _.each(scripts, function(file) {
              return chrome.tabs.executeScript(id, {
                file: file
              });
            });
          };
        })(this));
      }
    });
  });

}).call(this);
