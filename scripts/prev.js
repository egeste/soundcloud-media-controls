script = document.createElement('script');
script.type = "text/javascript";
script.text = "require(['lib/play-manager'],function(p) {p.playPrev();});"
document.head.appendChild(script);
document.head.removeChild(script);
