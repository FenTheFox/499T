/* 2014-06-20T16:23:49.295Z */!function(t,e){function n(t){var e=(new Date).getTime(),n=e-D;if(n>5e3?g.mt=E=[]:g.dt+=n,D=e,E.length<5){var o=r(t),l=o.x,a=o.y;(Math.abs(l-k)>10||Math.abs(a-A)>10)&&(k=l,A=a,E.push(l+","+a))}}function o(t){var e=t||window.event;n(e),x=0}function l(t){var e,n=t||window.event;(null===g.ex||null===g.ey)&&(e=r(n),g.ex=e.x,g.ey=e.y),null===g.ml?g.ml=1:g.ml++;var o=a(n);o&&(_=new Date-0,e=r(n),g.mox=e.x,g.moy=e.y,null===g.aml?g.aml=1:g.aml++)}function a(t){var e=t.srcElement?t.srcElement:t.target;if("A"!=e.tagName.toUpperCase()){for(var n=5;n>0;n--){if(e=e.parentNode,!e||!e.tagName)return null;if("A"==e.tagName.toUpperCase())break}if("A"!=e.tagName.toUpperCase())return null}return"undefined"==typeof e.href?null:"A"==e.tagName.toUpperCase()&&0!==e.getAttribute("href",2).indexOf("http")?null:e}function r(t){var e=t||window.event;return e.pageX||e.pageY?{x:e.pageX,y:e.pageY}:{x:e.clientX+document.body.scrollLeft-document.body.clientLeft,y:e.clientY+document.body.scrollTop-document.body.clientTop}}function i(t){var e=t||window.event;x=new Date-0,g.st=x-_;var n=r(e);g.mdx=n.x,g.mdy=n.y,4==e.button&&u(e),2==e.button&&u(e)}function u(t){x?(g.mc=new Date-x,x=0):g.mc=0;try{var e=t||window.event;if(clickobj=a(e),!clickobj)return;var n=(clickobj.getAttribute("href",2).match(/http:\/\/([^\/]+)/i)||["",""])[1];c(n)}catch(o){}}function c(n){var o=[1];o.push(g.ex+","+g.ey),o.push(g.ml),o.push(g.mox+","+g.moy),o.push(g.aml),o.push(g.mt.join("-")),o.push(g.dt),o.push(g.st),o.push(g.mdx+","+g.mdy),o.push(g.mc),o.push(g.hl),o.push(g.brws_w+"x"+g.brws_h),o=o.join("_"),o=o+"|"+m(o);for(var l=0;l<e.length;l++)if(v[e[l]]){var a=(new Date).getTime();t.img=new Image,t.img.id=a,t.img.src=decodeURIComponent(v[e[l]])+"&d_r="+n+"_"+(new Date).getTime().toString().substr(4)+"&tr="+o}}function m(t){var e,n=0;if(0===t.length)return n;for(w=0;w<t.length;w++)e=t.charCodeAt(w),n=(n<<5)-n+e;return(n>>>0).toString(16)}if(!t.__tanxclick_bind__){t.__tanxclick_bind__=!0;var s=document.body,d=location.href.split("?");d.shift();for(var h=(d.join("?")||"").split("&"),v={},w=0;w<h.length;w++){var p=h[w].split("=");v[p[0]]=v[p[0]]||p[1]}var f=!(!window.attachEvent||window.opera);f?(s.attachEvent("onclick",u),s.attachEvent("onmousemove",o),s.attachEvent("onmouseover",l),s.attachEvent("onmousedown",i)):(s.addEventListener("click",u,!1),s.addEventListener("mousemove",o,!1),s.addEventListener("mouseover",l,!1),s.addEventListener("mousedown",i,!1));var g={v:1,ex:null,ey:null,ml:null,mox:null,moy:null,aml:null,mt:[],dt:0,st:null,mdx:null,mdy:null,mc:null,hl:window.history.length,brws_w:null,brws_h:null},b=g.brws_w=s.clientWidth||0,y=g.brws_h=s.clientHeight||0;b&&y||setTimeout(function(){g.brws_w=s.clientWidth,g.brws_h=s.clientHeight},20);var x=0,_=0,E=[],k=0,A=0,D=(new Date).getTime()}}(window,["tanxclick","tanxdspv"]);