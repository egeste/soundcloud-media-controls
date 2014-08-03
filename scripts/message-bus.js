var eventStream, payload, script;

eventStream = function (id) {
  require(['event-bus'], function (eventBus) {
    eventBus.on('all', function (e,d) {
      chrome.runtime.sendMessage(id, {event:e,data:d}, function (response) {
        console.log(arguments);
      });
    });
  });
};

payload = '('+eventStream.toString()+')';
payload += '("'+chrome.runtime.id+'")';

script = document.createElement('script');
script.type = 'text/javascript';
script.text = payload;

document.head.appendChild(script);
document.head.removeChild(script);
