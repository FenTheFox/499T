LI.define("JSONPRequest");
LI.JSONPRequest=function(){this._init.apply(this,arguments)
};
LI.JSONPRequest.prototype={_requests:0,_init:function(a,c){this.url=a;
c=(YAHOO.lang.isFunction(c))?{on:{success:c}}:c||{};
var b=c.on||{};
if(!b.success){b.success=this._defaultCallback(a,c)
}this._config=YAHOO.lang.merge({context:this,args:[],format:this._format,allowCache:false},c,{on:b})
},_defaultCallback:function(){},send:function(){var a=this,d=Array.prototype.slice.call(arguments),c=a._config,e=a._proxy||a._uniqid(),b;
if(c.allowCache){a._proxy=e;
a._requests++
}d.unshift(a.url,"LI.JSONP."+e);
b=c.format.apply(a,d);
if(!c.on.success){return a
}function f(g){return(YAHOO.lang.isFunction(g))?function(h){if(!c.allowCache||!--a._requests){delete LI.JSONP[e]
}g.apply(c.context,[h].concat(c.args));
clearTimeout(LI.JSONPReqTimers[e])
}:null
}LI.JSONP[e]=f(c.on.success);
YAHOO.util.Get.script(b,{onFailure:f(c.on.failure),onTimeout:f(c.on.timeout),timeout:c.timeout});
if(c.timeout>0){LI.JSONPReqTimers[e]=setTimeout(f(c.on.timeout),c.timeout)
}return a
},_format:function(a,b){return a.replace(/\{callback\}/,b)
},_uniqid:function(){return("LI"+this._S4()+this._S4()+"_"+this._S4()+"_"+this._S4()+"_"+this._S4()+"_"+this._S4()+this._S4()+this._S4())
},_S4:function(){return(((1+Math.random())*65536)|0).toString(16).substring(1)
}};
if(!LI.JSONP){LI.JSONP={}
}if(!LI.JSONPReqTimers){LI.JSONPReqTimers={}
};LI.define("InviteDialog");
LI.InviteDialog=function(c,d){var j=this;
var a=(c.nodeName==="A");
var f,h,i;
d=d||{};
d={successRedirectURL:(d.successRedirectURL)?d.successRedirectURL:null,showGlobalSuccess:(d.showGlobalSuccess===false)?false:true};
this.onInviteSuccess=new YAHOO.util.CustomEvent("inviteSuccess");
function g(k){j.onInviteSuccess.fire(k);
if(d.successRedirectURL){document.location.href=d.successRedirectURL
}if(d.showGlobalSuccess){var l=LI.i18n.get("search-consumer-vcard-connect-success");
l=l.replace(/__(.*?)__/g,"{$1}");
l=YAHOO.lang.substitute(l,k);
LI.injectAlert(l,"success")
}f.close()
}function b(k){YDom.removeClass(h,"dialog-body-loading");
if(i){YDom.removeClass(i,"invite-dialog-loading")
}f.swap({content:{node:k}});
i=k;
LI.Controls.parseFragment(i);
e()
}function e(){if(!h){return
}var l=h.getElementsByTagName("form");
var n=function(o){var p=this;
YEvent.preventDefault(o);
function q(){p.submit()
}YDom.addClass(i,"invite-dialog-loading");
YAHOO.util.Connect.setForm(p,false);
$.ajax({url:p.action,type:"POST",data:$(p).serialize(),beforeSend:function(r){r.setRequestHeader("X-IsDialog","1");
r.setRequestHeader("X-IsAJAXForm","1")
},success:function(s){var r;
s=s.content||s;
if(s){if(typeof s==="object"&&s.status==="success"&&s.user){if(LI.Events){LI.Events.fire("inbox-pending-invite_pymk-invite-sent",s.user)
}g(s.user)
}else{if(LI.isFullPage(s)){r=$(".invite-content",s);
if(r.length){b(r)
}else{q()
}}}}else{q()
}},error:function(){q()
}})
};
for(var m=0,k=l.length;
m<k;
m++){YEvent.on(l[m],"submit",n)
}}YEvent.on(c,"click",function(k){var l=YEvent.getTarget(k);
if(k.metaKey){return true
}if(l.nodeName!=="A"){l=YDom.getAncestorByTagName(l,"a")
}if(l&&(a||YDom.hasClass(l,"invite-dialog"))){YEvent.preventDefault(k)
}j.open(l,k)
});
LI.InviteDialog.prototype.open=function(m,k){if(m&&(a||YDom.hasClass(m,"invite-dialog"))){var n=m.getAttribute("title");
if(!n||n===""){n=LI.i18n.get("InviteDialog-default-title")
}f=new LI.Dialog();
f.open(k||null,{content:{title:n,html:""},name:"one-click-invite-dialog",type:"task-modeless",className:"invite-dialog dialog-v2",width:"410"});
h=Y$("#dialog-wrapper .dialog-body",document,true);
if(h){YDom.addClass(h,"dialog-body-loading")
}LI.removeAlert(null,true);
var l=function(){document.location.href=m.href
};
YAHOO.util.Connect.initHeader("X-IsDialog","1");
YAHOO.util.Connect.asyncRequest("GET",m.href,{success:function(r){var q=document.createElement("div");
q.innerHTML=r.responseText;
var p=Y$(".invite-content",q,true);
if(p){b(p)
}else{l()
}},failure:function(){l()
}})
}}
};(function(){function a(b){if(LI.InviteDialog){var c=new LI.InviteDialog(b,{showGlobalSuccess:true});
c.onInviteSuccess.subscribe(function(j,g,l){var f=g[0],e,k,h,d;
e=YDom.getElementsByClassName("connect-link-"+f.id,"li",b);
d=e.length;
for(h=0;
h<d;
h++){k=e[h];
k.parentNode.removeChild(k)
}})
}}LI.SignalInviteDialog=a
})();var a;
(function(){var i=500,f=400,d="lui-panel-body",c={zIndex:1007,underlay:"none",close:false,draggable:false,visible:false},h="panel-left",e="miniprofile-container",g="data-li-miniprofile-id";
function b(l,j,k){this.url=l.className.split(" ")[1];
this.id=l.id;
this.node=l;
this.panel=j;
this.manager=k
}b.prototype={addListeners:function(){LI.Controls.parseFragment(this.panel.getDomNode());
YEvent.on("miniprofile-close","click",this.hide,this,true)
},calculatePosition:function(l){var m=this.node,j=YDom.getRegion(m),q=YDom.getViewportWidth(),n=YDom.getViewportHeight(),u=this.panel.getDomNode(),o=YDom.getRegion(u),k=o.width||0,p=o.height||0,s,r,t;
if(l===true){if((q-j.right)>k){s=j.right+3;
r=j.top-10;
t=false
}else{s=j.left-k;
r=j.top-10;
t=true
}}else{s=j.left-(k/2.4);
r=j.bottom+2;
t=false
}if(window.self!=window.top){s=(s<0)?0:s;
if(r+p>n){r=n-p-20
}}return{x:s,y:r,flipped:t}
},getID:function(){return this.id
},hide:function(){var j=this.panel;
this.removeListeners();
j.setBody("");
j.clearMiniProfileReference();
j.hide()
},removeListeners:function(){YEvent.removeListener("miniprofile-close","click",this.hide)
},setContent:function(j){this.content=j
},show:function(){var o=this.content,n=this.node,l=this.manager,j=this.panel,m,k=n.getAttribute("data-li-getjs");
if(!o&&o!==false){if(k){YAHOO.util.Get.script(k)
}l.requestContent(this.url,{success:function(p){if(!LI.isFullPage(p)){this.setContent(p);
this.show()
}},scope:this});
return
}if(o===false){return
}j.setBody(o);
this.addListeners();
if(n.getAttribute("data-li-panelclass")){j.setClass(n.getAttribute("data-li-panelclass"));
m=this.calculatePosition(false)
}else{m=this.calculatePosition(true)
}j.setMiniProfileReference(this.id);
j.show();
j.setPosition(m.x,m.y,m.flipped);
l.onShowMiniProfileEvent.fire()
},clearCachedData:function(){var j=this.manager;
j.removeFromCache(this.url)
}};
window.MiniProfileManager=(function(){var E={},w={},B={},r=false,u=null,A=null,k,t=false,n=false,s=new YAHOO.util.CustomEvent("onShowMiniProfile"),F=(YAHOO&&YAHOO.widget&&typeof YAHOO.widget.Overlay==="function")?true:false;
if(!F){var m;
if(!(LI&&LI.UrlPackage&&LI.UrlPackage.containerCore)){throw new Error("The package url for container-core does not exist.")
}m=LI.UrlPackage.containerCore;
YAHOO.util.Get.script(m,{onSuccess:function(){F=true
},onFailure:function(){throw new Error("Failed to load dependency: "+m)
}})
}function l(){if(!u&&r&&F){A=YDom.get(d);
if(!A){A=document.createElement("div");
document.body.appendChild(A);
A.id=d
}u=new YAHOO.widget.Overlay(A,c);
u.render(document.body);
YEvent.on(A,"mouseover",x);
YEvent.on(A,"mouseout",G)
}}k={setBody:function(I){l();
if(A){A.innerHTML=I
}},setPosition:function(I,K,J){l();
if(!u){return
}u.moveTo(I,K);
if(!J){YDom.removeClass(A,h)
}else{YDom.addClass(A,h)
}},setClass:function(I){l();
if(!u){return
}YDom.addClass(A,I);
u.hideEvent.subscribe(function(){YDom.removeClass(A,I);
u.hideEvent.unsubscribe()
})
},show:function(){l();
if(u){u.show()
}},hide:function(){l();
if(u){u.hide()
}},getDomNode:function(){l();
return A
},setMiniProfileReference:function(I){l();
if(A){A.setAttribute(g,I)
}},clearMiniProfileReference:function(){l();
if(A){A.setAttribute(g,"")
}}};
var q={requestShow:D,requestHide:o,requestContent:y,onShowMiniProfileEvent:s,removeFromCache:v};
YEvent.onDOMReady(function(){r=true
});
function H(J,I){E[J]=I
}function j(I){return E[I]
}function p(){if(!n&&!t){k.hide()
}}function D(I){n=true;
B[I.getID()]=window.setTimeout(function(){I.show()
},i)
}function o(){n=false;
window.setTimeout(p,f)
}function z(K,J){if(K&&K.success){var I=K.scope||window;
K.success.call(I,J)
}}function y(I,J){if(!YAHOO.lang.isUndefined(w[I])){z(J,w[I]);
return
}YAHOO.util.Connect.asyncRequest("GET",I,{success:function(L){var K=L.responseText||false;
w[I]=K;
z(J,K)
},failure:function(K){w[I]=false
}})
}function v(I){delete w[I]
}function x(){t=true
}function G(I){var L=YEvent.getRelatedTarget(I);
var K=YDom.get(d);
if(L==K){return
}var J=L;
if(YDom.isAncestor(K,J)){return
}t=false;
window.setTimeout(p,f)
}function C(){var I=YDom.get(d),J;
if(!I){return null
}J=I.getAttribute(g);
if(J){return j(J)
}return null
}YEvent.on(document,"mouseover",function(J){var L=YEvent.getTarget(J),K,I=C();
for(miniProfileId in B){if(YAHOO.lang.hasOwnProperty(E,miniProfileId)){window.clearTimeout(B[miniProfileId]);
delete B[miniProfileId]
}}while(L){if(YDom.hasClass(L,e)){if(!L.id){L.id=YDom.generateId()
}K=j(L.id);
if(!K){K=new b(L,k,q);
H(L.id,K)
}if(!u||!u.cfg.getProperty("visible")||!I||I.id!==K.id){D(K)
}return
}L=L.parentNode
}o()
});
return{init:function(){},getCurrentMiniProfile:C,onShowMiniProfileEvent:s}
})();
window.MiniProfileManager.init()
})();
window.miniProfile=window.MiniProfileManager;