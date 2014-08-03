var mainColor = '#f30',
    urlMatcher = '*://soundcloud.com/*',
    accentColor = '#f80',
    lastPlayingTab = null;

function getCanvas () {
  canvas = document.createElement('canvas');
  canvas.width = 38;
  canvas.height = 38;
  return canvas.getContext('2d');
};

function drawCircle (context, fill, stroke) {
  context.beginPath();
  context.arc(9.5, 9.5, 8.5, 0, 2 * Math.PI);
  context.strokeStyle = stroke || accentColor;
  context.lineWidth = 1;
  context.stroke();
  context.fillStyle = fill || mainColor;
  context.fill();
  context.closePath();
};

function playIcon (fill, stroke) {
  context = getCanvas();
  drawCircle(context, fill, stroke);
  context.beginPath();
  context.moveTo(7.125, 4.75);
  context.lineTo(14, 9.5);
  context.lineTo(7.125, 14);
  context.lineTo(8.3125, 9.5);
  context.lineTo(7.125, 4.75);
  context.strokeStyle = stroke || accentColor;
  context.lineWidth = 1;
  context.stroke();
  context.fillStyle = '#fff';
  context.fill();
  context.closePath();
  return context.getImageData(0, 0, 19, 19);
};

function pauseIcon (fill, stroke) {
  context = getCanvas();
  drawCircle(context, fill, stroke);
  context.beginPath()
  context.rect(6.0625, 4.75, 2.375, 9.5);
  context.rect(10.5625, 4.75, 2.375, 9.5);
  context.strokeStyle = stroke || accentColor;
  context.lineWidth = 1;
  context.stroke();
  context.fillStyle = '#fff';
  context.fill();
  context.closePath();
  return context.getImageData(0, 0, 19, 19);
};

function playing (event, tab) {
  lastPlayingTab = tab;
  chrome.browserAction.setIcon({ imageData: pauseIcon() });
};

function pausing (event, tab) {
  chrome.browserAction.setIcon({ imageData: playIcon() });
};

chrome.runtime.onMessageExternal.addListener(function (event, tab, cb) {
  switch (event.event) {
    case 'audio:play': playing(event, tab); break;
    case 'audio:pause': pausing(event, tab); break;
    default: console.log('Unhandled event', event, tab); break;
  };
});

function resolveActiveTab (tabs) {
  if (lastPlayingTab) return lastPlayingTab;
  for (var i = 0; i < tabs.length; i++) {
    if (tabs[i].active) { return tabs[i]; }
    if (tabs[i].selected) { return tabs[i]; }
    if (tabs[i].highlightd) { return tabs[i]; }
  };
  return tabs[0];
};

function executeScriptInActiveTab (file) {
  chrome.tabs.query({ url: urlMatcher }, function (tabs) {
    var target = resolveActiveTab(tabs);
    chrome.tabs.executeScript(target.id, { file: file });
  });
};

executeScriptInActiveTab('scripts/message-bus.js');

// Listen to relevant commands, and inject our control messages.
chrome.commands.onCommand.addListener(function (command) {
  var file;
  switch (command) {
    case 'next': file = 'scripts/next.js'; break;
    case 'previous': file = 'scripts/prev.js'; break;
    case 'play-pause': file = 'scripts/play_pause.js'; break;
  };
  if (file) executeScriptInActiveTab(file);
});
