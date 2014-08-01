resolveActiveTab = function (tabs) {
  for (var i = 0; i < tabs.length; i++) {
    if (tabs[i].active) { return tabs[i]; }
    if (tabs[i].selected) { return tabs[i]; }
    if (tabs[i].highlightd) { return tabs[i]; }
  }
  return tabs[0];
}

chrome.commands.onCommand.addListener(function (command) {
  chrome.tabs.query({ url: '*://soundcloud.com/*' }, function(tabs) {
    var payload, target = resolveActiveTab(tabs);
    switch (command) {
      case 'next': payload = 'scripts/next.js'; break;
      case 'previous': payload = 'scripts/prev.js'; break;
      case 'play-pause': payload = 'scripts/play_pause.js'; break;
    }
    chrome.tabs.executeScript(target.id, { file: payload });
  });
});
