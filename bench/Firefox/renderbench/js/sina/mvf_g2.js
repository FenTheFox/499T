var mediav = window.mediav || {};
mediav.browser = mediav.browser || {};
mediav.version = "1.0.2.1";
(function () {
    var a = navigator.userAgent;
    if (/(\d+\.\d)?(?:\.\d)?\s+safari\/?(\d+\.\d+)?/i.test(a) && !/chrome/i.test(a)) {
        mediav.browser.safari = +(RegExp["$1"] || RegExp["$2"])
    }
})();
if (/msie (\d+\.\d)/i.test(navigator.userAgent)) {
    mediav.browser.ie = mediav.ie = document.documentMode || +RegExp["$1"]
}
if (/opera\/(\d+\.\d)/i.test(navigator.userAgent)) {
    mediav.browser.opera = +RegExp["$1"]
}
mediav.url = mediav.url || {};
mediav.lang = mediav.lang || {};
mediav.lang.isArray = function (a) {
    return "[object Array]" == Object.prototype.toString.call(a)
};
mediav.url.queryToJson = function (a) {
    var f = a.substr(a.lastIndexOf("?") + 1),
        c = f.split("&"),
        e = c.length,
        k = {},
        d = 0,
        h, g, j, b;
    for (; d < e; d++) {
        if (!c[d]) {
            continue
        }
        b = c[d].split("=");
        h = b[0];
        g = decodeURIComponent(b[1]);
        j = k[h];
        if ("undefined" == typeof j) {
            k[h] = g
        } else {
            if (mediav.lang.isArray(j)) {
                j.push(g)
            } else {
                k[h] = [j, g]
            }
        }
    }
    return k
};
mediav.url.escapeSymbol = function (a) {
    return String(a).replace(/\%/g, "%25").replace(/&/g, "%26").replace(/\+/g, "%2B").replace(/\ /g, "%20").replace(/\//g, "%2F").replace(/\#/g, "%23").replace(/\=/g, "%3D").replace(/\?/g, "%3F")
};
mediav.url.jsonToQuery = function (h, j, g) {
    var k = [],
        d, b = j ||
    function (i) {
        return mediav.url.escapeSymbol(i)
    };
    for (var c = 0, a = g.length; c < a; c++) {
        var e = g[c];
        var f = h[e];
        if (f != null) {
            k.push(e + "=" + b(f, e))
        }
    }
    return k.join("&")
};
mediav.string = {};
mediav.string.format = function (c, a) {
    c = String(c);
    var b = Array.prototype.slice.call(arguments, 1),
        d = Object.prototype.toString;
    if (b.length) {
        b = b.length == 1 ? (a !== null && (/\[object Array\]|\[object Object\]/.test(d.call(a))) ? a : b) : b;
        return c.replace(/#\{(.+?)\}/g, function (e, g) {
            var f = b[g];
            if ("[object Function]" == d.call(f)) {
                f = f(g)
            }
            return("undefined" == typeof f ? "" : f)
        })
    }
    return c
};
mediav.G = function (a) {
    return document.getElementById(a)
};
mediav.getFixed = function (a, b) {
    b = b || 2;
    return(a + Math.pow(10, b) + "").substr(1, b)
};
var mv_impid;
(function () {
    function a(e) {
        var d = 1,
            c = 0,
            b;
        if (e) {
            d = 0;
            for (b = e.length - 1; b >= 0; b--) {
                c = e.charCodeAt(b);
                d = (d << 6 & 268435455) + c + (c << 14);
                c = d & 266338304;
                d = c != 0 ? d ^ c >> 21 : d
            }
        }
        return d
    }
    mediav.getUID = function () {
        var b = mediav._uid;
        if (b) {
            return b
        }
        var f = (new Date() - 0);
        var c = window.location.href;
        var e = a(c);
        b = "" + f + e + Math.random() + Math.random() + Math.random() + Math.random();
        b = b.replace(/\./g, "").substring(0, 32);
        mediav._uid = b;
        return b
    }
})();
mediav.getImpid = function () {
    if (mv_impid) {
        return mv_impid
    }
    var a = [];
    var b = new Date();
    a.push(Math.floor(Math.random() * 991) + 1);
    a.push(mediav.getFixed(b.getMilliseconds(), 3));
    a.push(999);
    a.push(mediav.getFixed(b.getSeconds()));
    a.push(mediav.getFixed(b.getMinutes()));
    a.push(mediav.getFixed(b.getHours()));
    a.push(mediav.getFixed(b.getDate()));
    a.push(mediav.getFixed(b.getMonth() + 1));
    mv_impid = a.join("");
    return mv_impid
};
mediav.ad || (mediav.ad = {});
mediav.otherBannerIds || (mediav.otherBannerIds = []);
mediav.otherCreativeIds || (mediav.otherCreativeIds = []);
mediav.ad.wraps = mediav.ad.wraps || {};
mediav.ad.status = mediav.ad.status || {};
mediav.ad.pubs = mediav.ad.pubs || {};
mediav.initInnerConfig = function () {
    window.mv_bid && mediav.otherCreativeIds.push(window.mv_bid);
    mediav.configs = {
        ad: {
            logo: true,
            repeat: false,
            db: "mediav",
            asyn: false,
            unique: true
        },
        "default": {
            overtime: 3
        },
        other: {
            keyword: "",
            adtest: false,
            ref: true
        }
    }
};
(function () {
    var e = ["mediav_ad_ref", "mediav_ad_wrap", "mediav_ad_pub", "mediav_ad_width", "mediav_ad_height", "mediav_ad_logo", "mediav_ad_repeat", "mediav_ad_async", "mediav_ad_host", "mediav_ad_db", "mediav_ad_mainurl", "mediav_default_material", "mediav_default_clickurl", "mediav_default_turl", "mediav_default_overtime", "mediav_keyword", "mediav_adtest", "mediav_ad_listenurl", "mediav_ad_unique"];

    function b(g, i) {
        var f = g.split("_"),
            h = f[1],
            j = f[2];
        if (j) {
            mediav.configs[h][j] = i
        } else {
            mediav.configs.other[h] = i
        }
    }
    function d() {
        c(window);
        mediav.ad.clearGlobalVar()
    }
    function a(f) {
        c(f)
    }
    function c(j) {
        for (var g = e.length; g; g--) {
            var f = e[g - 1],
                h = j[f];
            if (h != null) {
                b(f, h)
            }
        }
    }
    mediav.ad.clearGlobalVar = function () {
        for (var g = e.length; g; g--) {
            var f = e[g - 1];
            if (window[f] != undefined && window[f] != null) {
                window[f] = null
            }
        }
    };
    mediav.ad.initConfig = function (i) {
        if (i) {
            a(i)
        } else {
            if (window.mediav_ad_pub) {
                d()
            }
        }
        if (!mediav.configs.ad.pub) {
            return true
        }
        var f = mediav.configs.ad.pub.split("_");
        mediav.configs.ad.pub = f[1] || f[0];
        mediav.configs.ad.showid = f[0];
        mediav.ad.pubs[f[1]] = 1;
        if (mediav.configs.ad.wrap) {
            mediav.ad.wraps[mediav.configs.ad.pub] = mediav.configs.ad.wrap;
            mediav.configs.ad.async = true
        }
        var g = mediav.configs["default"].clickurl;
        var h = mediav.configs["default"].turl;
        if (g) {
            mediav.configs["default"].clickurl = g.replace(/\?type=\d/, function (j) {
                return j + "&impid=" + mediav.getImpid()
            })
        }
        if (h) {
            mediav.configs["default"].turl = h.replace(/\?type=\d/, function (j) {
                return j + "&impid=" + mediav.getImpid()
            })
        }
    }
})();
mediav.ad.listen = function (c, b) {
    var a = new Image();
    a.onload = a.onerror = window[c + "_mv_" + (new Date() - 0)] = function () {};
    a.src = b
};
mediav.ad.startAdStateCheck = function (g, j, b) {
    var i = "<a href='#{0}' target='_blank'><img width='#{1}' height='#{2}' border='' alt='' src='#{3}'></img></a>";
    var h = mediav.configs.ad.pub;

    function e() {
        if (window["mediav_fini" + h]) {
            return true
        }
        return false
    }
    function c() {
        return mediav.string.format(i, j.clickurl || "javascript:void(0)", b.width, b.height, j.material)
    }
    function f() {
        if (!e()) {
            var k = b.pub;
            mediav.G(g).innerHTML = c();
            j.turl && a(j.turl);
            var l = mediav.G("mvlogo_" + k);
            l && (l.style.display = "block");
            d()
        }
    }
    function a(l) {
        var k = new Image();
        k.src = l;
        k.onerror = (k.onload = (k.onabort = function () {
            k = null
        }))
    }
    function d() {
        mediav.ad.status[h] = "stop";
        var m = "mvscr" + h;
        var l = document.getElementById(m);
        if (l.clearAttributes) {
            l.clearAttributes()
        } else {
            for (var k in l) {
                if (l.hasOwnProperty(k)) {
                    delete l[k]
                }
            }
        }
        if (l && l.parentNode) {
            l.parentNode.removeChild(l)
        }
        l = null
    }
    setTimeout(f, j.overtime * 1000)
};
mediav.ad.getPubName = function (a) {
    return "showid"
};
mediav.ad.getScriptUrl = function (b, a, c) {
    var d = ["showid", "type", "of", "adtest", "keyword", "bids", "ref", "refer", "uid"];
    var e = {
        type: 1,
        of: 1
    };
    b.unique && (e.uid = mediav.getUID());
    e[mediav.ad.getPubName(b.pub)] = b.showid;
    b.refer && document.referrer && (e.refer = encodeURIComponent(document.referrer));
    c.adtest && (e.adtest = c.adtest);
    c.keyword && (e.keyword = c.keyword);
    b.ref && (e.ref = b.ref);
    mediav.otherBannerIds.push(b.pub);
    return mediav.url.jsonToQuery(e, null, d)
};
mediav.ad.getScriptHTML = function (g, d) {
    var a = mediav.configs.ad;
    var e = a.host || "show.g.mediav.com/s";
    var f = "http://" + e + "?" + mediav.ad.getScriptUrl(mediav.configs.ad, mediav.configs["default"], mediav.configs.other);
    if (d) {
        var c = document.createElement("script");
        g && (c.id = g);
        c.type = "text/javascript";
        c.async = true;
        c.charset = "utf-8";
        c.src = f;
        var b = document.getElementsByTagName("script")[0];
        b.parentNode.insertBefore(c, b);
        return ""
    } else {
        return '<SCRIPT id="' + g + '" LANGUAGE="JavaScript" src="' + f + '" charset="utf-8"></SCRIPT>'
    }
};
mediav.logo || (mediav.logo = {});
mediav.logo.getHtml = function (b) {
    var e = "mvlogo_" + mediav.configs.ad.pub;
    var c = '<a id="#{3}" target="_blank" style="display:none;position:absolute;z-index:4;right:0;top:#{2}px" href="http://www.mediav.com/" onmouseover="mediav.logo.over(this)" onmouseout="mediav.logo.out(this)"><img style="border:0" src="#{0}"/><img src="#{1}" style="display:none;border:0"/></a>';
    if (!window.XMLHttpRequest) {
        var d = "http://material.mediav.com/js/v1.gif";
        var a = "http://material.mediav.com/js/mediav1.gif"
    } else {
        var d = "http://material.mediav.com/js/v1.png";
        var a = "http://material.mediav.com/js/mediav1.png"
    }
    return mediav.string.format(c, d, a, mediav.configs.ad.height - 18, b ? e : "")
};
mediav.logo.over = function (a) {
    a.firstChild.style.display = "none";
    a.lastChild.style.display = "block"
};
mediav.logo.out = function (a) {
    a.lastChild.style.display = "none";
    a.firstChild.style.display = "block"
};
mediav.ad.write = function (d) {
    if (mediav.ad.initConfig(d)) {
        return
    }
    var c = mediav.configs.ad.pub;
    var e = mediav.configs.ad.listenurl;
    mediav["lisen" + c] = function () {
        if (!e) {
            return
        }
        mediav.ad.listen(c, e)
    };
    var b = "mvdiv_" + mediav.configs.ad.pub;
    var i = "mvscr" + mediav.configs.ad.pub;
    var h = [];
    h.push("<div id='" + b + "_holder' style='display:block;float:none;width:" + mediav.configs.ad.width + "px;height:" + mediav.configs.ad.height + "px'>");
    h.push("<div style='display:block;float:none;position:relative;z-index:4;width:" + mediav.configs.ad.width + "px;overflow:visible'>");
    h.push("<div id='" + b + "' style='display:block;float:none'>");
    h.push("</div>");
    h.push(mediav.logo.getHtml(mediav.configs.ad.logo));
    h.push("</div></div>");
    var f = (mediav.ad.getScriptHTML(i, mediav.configs.ad.async));
    if (mediav.configs.ad.wrap) {
        mediav.G(mediav.configs.ad.wrap).innerHTML = h.join("")
    } else {
        document.write(h.join(""));
        document.write(f)
    }
    if (mediav.configs["default"].material) {
        mediav.ad.startAdStateCheck(b, mediav.configs["default"], mediav.configs.ad)
    }
    var a = document.getElementById(b);
    var g = "lisen" + mediav.configs.ad.pub;
    a.parentNode.parentNode.parentNode.onclick = function () {
        mediav[g]()
    };
    if (window.mediav_ad_pub && window.mediav_ad_pub.indexOf(mediav.configs.ad.pub) >= 0) {
        window.mediav_ad_pub == null
    }
};
mediav.ad.init = function (a) {
    mediav.initInnerConfig();
    mediav.ad.write(a)
};
mediav.ad.init();
mediav.product = mediav.product || {
    compute: 0,
    autoPlayObj: null,
    moveLock: false,
    playCount: 0
};
mediav.product.init = function (b) {
    var a = this;
    a.container = b[0] ? b[0] : "";
    a.element1 = b[1] ? b[1] : "";
    a.element2 = b[2] ? b[2] : "";
    a.speed = b[3] ? b[3] : 100;
    a.interval = b[4] ? b[4] : 5000;
    a.playNum = b[5] ? b[5] : 0;
    a.space = b[6] ? b[6] : 10;
    a.blockWidth = b[7] ? b[7] : 100;
    a.fill = b[8] ? b[8] : 0;
    a.autoflag = b[9] ? b[9] : false;
    a.direction = b[10] ? b[10] : "right"
};
mediav.product.template = function (a, b) {
    a = String(a);
    return a.replace(/#\{(.+?)\}/g, function (c, f) {
        var g = f.split("_");
        try {
            var d = b[g[0]][g[1]];
            if ("[object Function]" == Object.prototype.toString.call(d)) {
                d = d(f)
            }
        } catch(h) {}
        return("undefined" == typeof d ? "" : d)
    })
};
mediav.product.getQueryString = function getQueryString(b, a) {
    var c = new RegExp("(^|&)" + a + "=([^&]*)(&|$)", "i");
    var d = b.substr(1).match(c);
    if (d != null) {
        return unescape(d[2])
    }
    return null
};
mediav.product.combineAmbitionClickUrl = function (d) {
    var i = this;
    var f = "",
        h = "",
        b = "0_0_0",
        e = "0_0_0_0_0",
        c = "http://show.g.mediav.com/c?type=2&db=mediav";
    var a = d.match(/cus=[0-9]+_[0-9]+_[0-9]+_[0-9]+_[0-9]+/);
    var g = d.match(/pub=[0-9]+_[0-9]+_[0-9]+/);
    if (a) {
        e = a.toString().replace("cus=", "")
    }
    if (g) {
        b = g.toString().replace("pub=", "")
    }
    h = i.getQueryString(d, "oimpid");
    f = i.getQueryString(d, "ref");
    c = c + "&oimpid=" + h + "&pub=" + b + "&cus=" + e + "&ref=" + f;
    return c
};
mediav.product.combineDspClickUrl = function (b) {
    var a = b.match(/&url=http.[^&]+/g);
    if (a.length > 1) {
        url = a[a.length - 1]
    } else {
        url = a[0]
    }
    prefix = b.replace(url, "");
    return prefix
};
mediav.product.getFixedText = function (g, a) {
    var c = g.split(""),
        f = 0,
        e = 0.6,
        b = "";
    if (c.length > 0) {
        for (var d = 0; d < c.length; d++) {
            /[0-9|a-z]/i.test(c[d]) ? f += e : f += 1;
            if (f > a) {
                return b
            } else {
                b += c[d]
            }
        }
    }
    return b
};
mediav.product.changeData = function (k, g, j, b) {
    var m = this;
    var e = b.entity ? b.entity : "ambition";
    if (e == "ambition") {
        k = m.combineAmbitionClickUrl(k)
    } else {
        k = m.combineDspClickUrl(k)
    }
    var l = k.match(/cus=[0-9]+_[0-9]+_[0-9]+_[0-9]+_[0-9]+/);
    l = l.toString().replace("cus=", "");
    var d = l.split("_");
    if (j != null) {
        var a = j.split(",")
    } else {
        var a = []
    }
    for (var f = 0; f < g.length; f++) {
        if (g[f]["curl"]) {
            if (a.length > 0 && d.length > 0) {
                clickid = a[f] ? a[f] : 0;
                d[d.length - 1] = clickid;
                new_cus = d.join("_");
                newClickUrl = k.replace("cus=" + l, "cus=" + new_cus)
            }
            g[f]["curl"] = newClickUrl + "&url=" + g[f]["curl"]
        }
        if (g[f]["price"] && b.priceLength) {
            var h = String(g[f]["price"]);
            g[f]["price"] = h.substring(0, b.priceLength)
        }
        if (g[f]["pn"] && b.pnLength) {
            var c = String(g[f]["pn"]);
            g[f]["opn"] = c;
            g[f]["pn"] = m.getFixedText(c, b.pnLength)
        }
    }
    return g
};
mediav.product.clone = function (c) {
    if (typeof (c) != "object") {
        return c
    }
    if (c == null) {
        return c
    }
    var b = new Object();
    for (var a in c) {
        if (c.hasOwnProperty(a)) {
            b[a] = this.clone(c[a])
        }
    }
    return b
};
mediav.product.marquee = function (h, b, n, m, d, c, e, a, i, p, k, l) {
    var j = h;
    var f = mediav.product.clone(mediav.product);
    var o = f;
    var g = Array.prototype.slice.call(arguments, 1);
    o.init(g);
    window[j] = f;
    mediav.G(m).innerHTML = mediav.G(n).innerHTML;
    mediav.G(b).scrollLeft = p;
    if (k) {
        mediav.G(b).onmouseover = function () {
            clearInterval(o.autoPlayObj)
        };
        mediav.G(b).onmouseout = function () {
            o.autoPlay(1)
        };
        o.autoPlay()
    }
};
mediav.product.autoPlay = function (b) {
    var a = this || mediav.product;
    clearInterval(a.autoPlayObj);
    if (a.playNum > 0) {
        if (!b && a.playCount <= a.playNum) {
            a.playCount++
        }
        if (a.playCount > a.playNum) {
            return
        }
    }
    if (a.direction == "right") {
        a.autoPlayObj = setInterval(function () {
            a.moveToRight()
        }, a.interval)
    } else {
        a.autoPlayObj = setInterval(function () {
            a.moveToLeft()
        }, a.interval)
    }
};
mediav.product.moveToLeft = function (e) {
    var b = this || mediav.product;
    if (b.moveLock) {
        return
    }
    clearInterval(b.autoPlayObj);
    b.moveLock = true;
    var a = mediav.G(b.container);
    var d = mediav.G(b.element1);
    var c = d.offsetWidth;
    if (a.scrollLeft <= 0) {
        a.scrollLeft = a.scrollLeft + c
    }
    a.scrollLeft -= b.space;
    if (a.scrollLeft % b.blockWidth - b.fill != 0) {
        b.compute = b.fill - (a.scrollLeft % b.blockWidth);
        b.computeScroll()
    } else {
        b.moveLock = false
    }
    if (b.autoflag) {
        b.autoPlay(e)
    }
};
mediav.product.moveToRight = function (e) {
    var b = this || mediav.product;
    if (b.moveLock) {
        return
    }
    clearInterval(b.autoPlayObj);
    b.moveLock = true;
    var a = mediav.G(b.container);
    var d = mediav.G(b.element1);
    var c = d.scrollWidth;
    if (a.scrollLeft >= c) {
        a.scrollLeft = a.scrollLeft - c
    }
    a.scrollLeft += b.space;
    if (a.scrollLeft % b.blockWidth - b.fill != 0) {
        b.compute = b.blockWidth - a.scrollLeft % b.blockWidth + b.fill;
        b.computeScroll()
    } else {
        b.moveLock = false
    }
    if (b.autoflag) {
        b.autoPlay(e)
    }
};
mediav.product.computeScroll = function () {
    var c, b = this || mediav.product;
    var a = mediav.G(b.container);
    var d = a.scrollLeft;
    if (b.compute == 0) {
        b.moveLock = false;
        return
    }
    if (b.compute < 0) {
        if (b.compute < -b.space) {
            b.compute += b.space;
            c = b.space
        } else {
            c = -b.compute;
            b.compute = 0
        }
        d -= c;
        a.scrollLeft = d;
        setTimeout(function () {
            b.computeScroll()
        }, b.speed)
    } else {
        if (b.compute > b.space) {
            b.compute -= b.space;
            c = b.space
        } else {
            c = b.compute;
            b.compute = 0
        }
        d += c;
        a.scrollLeft = d;
        setTimeout(function () {
            b.computeScroll()
        }, b.speed)
    }
};
(function () {
    function a(c, k, g, m, j, h, e) {
        var b = h ? window["mvas_" + h] : "";
        if (mediav.ad.pubs[b] != 1) {
            return
        }
        var p = "";
        if (mediav.ad.status[b] == "stop") {
            return
        }
        if (mediav.ad.wraps[b]) {
            var p = mediav.G("mvdiv_" + b)
        }
        var n = mediav.G("mvdiv_" + b + "_holder");
        var f = mediav.G("mvlogo_" + b);
        f && (f.style.display = "block");
        var o = mediav.G("mvdiv_" + b);
        o && (o.style.display = "none");
        n && (n.style.height = 0);
        var d = "mv_swf_" + b || (new Date() - 0);
        var e = e || "Opaque";
        var l = "<OBJECT id=" + d + ' codeBase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7" classid=clsid:D27CDB6E-AE6D-11cf-96B8-444553540000 width=' + c + " height=" + k + ' type=application/x-shockwave-flash><PARAM NAME="Movie" VALUE="' + g + '"><PARAM NAME="FlashVars" VALUE="mv_clickurl=' + escape(j) + '"><PARAM NAME="WMode" VALUE="' + e + '"><PARAM NAME="Quality" VALUE="High"><PARAM NAME="AllowScriptAccess" VALUE="always"><PARAM NAME="Scale" VALUE="ShowAll"><PARAM NAME="AllowNetworking" VALUE="all"><PARAM NAME="AllowFullScreen" VALUE="false"><embed id="' + d + '" width="' + c + 'px" height="' + k + 'px" src="' + g + '" quality="High" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" wmode="' + e + '" allowscriptaccess="always" FlashVars="mv_clickurl=' + escape(j) + '"></embed></OBJECT>';
        if (m == 1) {
            var i = '<div style="width:' + c + "px;height:" + k + 'px;overflow:hidden">' + l + "</div>"
        } else {
            var i = '<div style="width:' + c + "px;height:" + k + 'px;overflow:hidden"><div style="position: relative; z-index: 1; width:' + +c + "px; height:" + k + 'px;"><div style=";overflow:hidden;position: absolute; left: 0pt; top: 0pt; z-index: 2; width:' + c + "px; height:" + k + 'px;">';
            i += l;
            i += '</div><a id="mvclicka" target="_blank" href="' + j + '"><img border="0" style="position: absolute; left: 0px; top: 0px; z-index: 3; width:' + c + "px;height:" + k + 'px;" src="http://static.mediav.com/1x1.gif"/></a></div></div>'
        }
        if (p == "") {
            document.write(i)
        } else {
            p.innerHTML = i;
            p.style.display = "block"
        }
    }
    mediav.makeImage = function (g, d, c, l, i) {
        var e = i ? window["mvas_" + i] : "";
        var forbidHTML = function(source) {
            return String(source)
            .replace(/</g, '')
            .replace(/>/g, '')
            .replace(/"/g, '')
            .replace(/'/g, '');
        }
        var d = forbidHTML(d.replace(/\<\w+\>.+\<\/\w+\>/g, ""));
        var b = "";
        if (mediav.ad.status[e] == "stop") {
            return
        }
        var j = mediav.G("mvdiv_" + e + "_holder");
        var f = mediav.G("mvlogo_" + e);
        f && (f.style.display = "block");
        j && (j.style.height = 0);
        var k = mediav.G("mvdiv_" + e);
        k && (k.style.display = "none");
        if (mediav.ad.wraps[e]) {
            var b = mediav.G("mvdiv_" + e)
        }
        var h = mediav.string.format('<a href="#{0}" target="_blank"><img src="#{1}" alt="" border="" width="#{2}" height="#{3}"></img></a>', d, g, c, l);
        if (b) {
            b.innerHTML = h;
            b.style.display = "block"
        } else {
            document.write(h)
        }
    };
    mediav.makeFlash = a;
    mediav.makeNone = function () {};
    mediav.makeProduct = function (j, l, g, o, k, p, d) {
        var c = j ? window["mvas_" + j] : "";
        var b = "";
        if (mediav.ad.status[c] == "stop") {
            return
        }
        var m = mediav.G("mvdiv_" + c + "_holder");
        var e = mediav.G("mvlogo_" + c);
        e && (e.style.display = "block");
        m && (m.style.height = 0);
        var n = mediav.G("mvdiv_" + c);
        n && (n.style.display = "none");
        if (mediav.ad.wraps[c]) {
            var b = mediav.G("mvdiv_" + c)
        }
        if (p && p.length > 0) {
            for (var f = 0; f < p.length; f++) {
                g.push(p[f])
            }
        }
        g = mediav.product.changeData(l, g, k, d);
        var h;
        h = o.join("");
        h = mediav.product.template(h, g);
        if (b) {
            b.innerHTML = h;
            b.style.display = "block"
        } else {
            document.write(h)
        }
    }
})();