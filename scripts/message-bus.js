var messageBus, payload, script;

chrome.runtime.onMessage.addListener(function (command) {
  window.postMessage(command, '*');
});

messageBus = function (id) {
  require(['event-bus'], function (eventBus) {
    eventBus.on('all', function (event, data) {
      chrome.runtime.sendMessage(id, { data: data, event: event });
    });
  });
  require(['lib/play-manager'], function (playManager) {
    window.addEventListener('message', function (event) {
      switch (event.data) {
        case 'next': playManager.playNext(); break;
        case 'previous': playManager.playPrev(); break;
        case 'play-pause': playManager.toggleCurrent(); break;
      };
    });
  });
};

payload = '('+messageBus.toString()+')';
payload += '("'+chrome.runtime.id+'")';

script = document.createElement('script');
script.type = 'text/javascript';
script.text = payload;

document.head.appendChild(script);
document.head.removeChild(script);
