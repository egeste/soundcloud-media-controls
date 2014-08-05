(function() {
  define(['oraculum', 'oraculum/libs'], function(Oraculum) {
    'use strict';
    var _;
    _ = Oraculum.get('underscore');
    return Oraculum.defineMixin('TrackPlayingTab.ExtensionMixin', {
      mixinOptions: {
        trackPlayingTab: {
          urlMatcher: ''
        }
      },
      mixinitialize: function() {
        chrome.tabs.onUpdated.addListener(this.trackPlayingTab);
        chrome.tabs.onRemoved.addListener(this.trackPlayingTab);
        chrome.tabs.onActivated.addListener(this.trackPlayingTab);
        chrome.runtime.onMessageExternal.addListener((function(_this) {
          return function(_arg, _arg1) {
            var event, tab;
            event = _arg.event;
            tab = _arg1.tab;
            if (event === 'audio:playing') {
              return _this.trackPlayingTab(tab);
            }
          };
        })(this));
        return this.trackPlayingTab();
      },
      trackPlayingTab: function(tab) {
        var urlMatcher;
        if (tab) {
          return this.playingTab = tab;
        }
        if (this.playingTab) {
          return this.playingTab;
        }
        urlMatcher = this.mixinOptions.trackPlayingTab.urlMatcher;
        return chrome.tabs.query({
          url: urlMatcher
        }, (function(_this) {
          return function(tabs) {
            if (!tabs) {
              return;
            }
            _.each(tabs, function(tab) {
              if (tab.active) {
                return _this.playingTab = tab;
              }
              if (tab.selected) {
                return _this.playingTab = tab;
              }
              if (tab.highlighted) {
                return _this.playingTab = tab;
              }
            });
            return _this.playingTab = tabs[0];
          };
        })(this));
      }
    });
  });

}).call(this);
