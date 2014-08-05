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
        _.bindAll(this, '_handleUpdate');
        urlMatcher = this.mixinOptions.injectContentScripts.urlMatcher;
        chrome.tabs.onUpdated.addListener(this._handleUpdate);
        return chrome.tabs.query({
          url: urlMatcher
        }, (function(_this) {
          return function(tabs) {
            return _.each(tabs, function(tab) {
              return _this.injectContentScripts(tab);
            });
          };
        })(this));
      },
      _handleUpdate: function(id, update, tab) {
        if (update.status !== 'complete') {
          return;
        }
        return this.injectContentScripts(tab);
      },
      injectContentScripts: function(tab) {
        var regexMatcher, scripts, urlMatcher;
        urlMatcher = this.mixinOptions.injectContentScripts.urlMatcher;
        regexMatcher = urlMatcher.replace('*', '.*');
        if (!tab) {
          return;
        }
        if (!RegExp("" + regexMatcher, "i").test(tab.url)) {
          return;
        }
        scripts = this.mixinOptions.injectContentScripts.scripts;
        return _.each(scripts, function(file) {
          return chrome.tabs.executeScript(tab.id, {
            file: file
          });
        });
      }
    });
  });

}).call(this);
