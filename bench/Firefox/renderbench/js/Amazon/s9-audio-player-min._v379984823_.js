S9AudioPlayer=true;
var loadS9AudioPlayer=function(b){b.fn.s9AudioPlayer=function(d){var c={realm:"USAmazon",playingText:"Pause sample",loadingText:"Loading...",pausedText:"Sample"};
d=b.extend({},c,d);
this.each(function(){new a(b(this),d)
});
return this
};
function a(i,k){this.options=k;
var e={callback:h,reset:function(){},setVolume:function(){},toggleMute:function(){}};
var c=null;
function l(){i.find(".s9_trackPreviewContainer").unbind("click").click(f)
}function f(o){var n=b(this).data("s9PlayerState");
switch(n){case"playing":case"loading":j();
break;
case"paused":case undefined:var p=b(this).attr("trackasin");
if(p){d(p,"asin");
break
}var m=b(this).attr("trackurl");
if(m){d(m,"url");
break
}break
}o.preventDefault()
}function d(m,n){if(c){g("paused")
}c=m;
g("loading");
switch(n){case"asin":Mp3Interface.playSongAsin(m,k.realm,e);
break;
case"url":Mp3Interface.playSong(m,e);
break
}}function j(){Mp3Interface.pauseSong(e);
c=null
}function h(m){switch(m){case"onPlayerInit":l();
break;
case"onLoad":break;
case"onPlay":g("playing");
break;
case"onPause":case"onStop":case"onComplete":case"onIOError":case"onInvalidUrl":g("paused")
}}function g(o){var q=i.find('a.s9_trackPreviewContainer[trackasin="'+c+'"], a.s9_trackPreviewContainer[trackurl="'+c+'"]');
var n=q.find(".s9_trackPreviewState");
if(n){n.text(k[o+"Text"])
}var m=o.replace(/^./,function(r){return r.toUpperCase()
});
var p=q.get(0);
if(p){p.className=p.className.replace(new RegExp(" s9_trackPreviewState\\w+"),"");
p.className+=" s9_trackPreviewState"+m
}q.data("s9PlayerState",o)
}if(window.Mp3Interface){Mp3Interface.registerPlayer(e)
}return e
}if(window.amznJQ!==undefined){amznJQ.declareAvailable("S9AudioPlayer")
}};
if(window.amznJQ!==undefined){amznJQ.onReady("jQuery",function(){loadS9AudioPlayer(jQuery)
})
}else{if(window.P!==undefined){P.when("A","ready").register("S9AudioPlayer",function(a){loadS9AudioPlayer(a.$)
})
}};