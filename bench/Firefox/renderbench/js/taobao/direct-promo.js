/**
 * @fileOverview 定投模块
 * @author 莫争 <gaoli.gl@taobao.com>
 * @version 1.0
 */

(function(S) {

  var FP = {};

  var API      = 'http://delta.taobao.com/home/delivery/AllContentByPage.do',
      IDS      = [],
      IDS_Q75  = [],
      IDS_LAZY = [];

  var RENDER_COUNT = 0,
      FEELING_LUCK = parseInt(Math.random() * 10000) === 7 ? true : false;

  var RE_Q75  = /_q75$/i,
      RE_JPG  = /^https?:\/\/\S+(jpg)$/i,
      RE_PIC  = /^https?:\/\/\S+(png|jpg|gif)$/i,
      RE_URL  = /^https?:\/\/\S+$/i;

  var SPACE = ' ';

  /**
   * Util
   */
  var Util  = function() {};

  /**
   * Class 选择器
   * @param  {String} cls
   * @param  {String} context
   * @return {Array}
   */
  Util.prototype.selector = function(cls, context) {
    var self = this,
        node = context ? document.getElementById(context) || context : document,
        res  = [];

    if (document.querySelectorAll) {
      return node.querySelectorAll('.' + cls);
    } else {
      var els = node.getElementsByTagName('*'),
          len = els.length,
          ret = [];

      for (var i = 0; i < len; i++) {
        var el = els[i];
        util.hasClass(el, cls) && ret.push(el);     
      }

      return ret;
    }
  };

  /**
   * Class 判断
   * @param  {Object} el
   * @param  {String} cls
   * @return {Boolean}
   */
  Util.prototype.hasClass = function(el, cls) {
    var className = el && el.className;
    return className && (SPACE + className + SPACE).indexOf(SPACE + cls + SPACE) > -1;
  };

  /**
   * Class 添加
   * @param {Object} el
   * @param {String} cls
   */
  Util.prototype.addClass = function(el, cls) {
    var className = el && el.className;

    if (el) {
      className = (SPACE + className + SPACE);
      !~className.indexOf(SPACE + cls + SPACE) && (el.className = S.trim(className + cls));
    }
  };

  /**
   * Class 去除
   * @param {Object} el
   * @param {String} cls
   */
  Util.prototype.removeClass = function(el, cls) {
    var className = el && el.className;

    if (className) {
      className = (SPACE + className + SPACE).replace(SPACE + cls + SPACE, SPACE);
      el.className = S.trim(className);
    }
  };

  var util = new Util();

  /**
   * DirectPromo
   */
  var DirectPromo = function() {};

  /**
   * 程序初始化
   */
  DirectPromo.prototype.init = function() {
    this.render();
  };

  /**
   * 渲染界面
   * @param {String} wrap
   */
  DirectPromo.prototype.render = function(wrap) {
    var self = this;

    !IDS.length && self.collect(wrap);
    self.getData();

    // 统计渲染时间
    FEELING_LUCK && self.emit('tb_index_direct_promo_render', {
      render: ++ RENDER_COUNT,
      time  : new Date()
    });

    // 清空定投数据
    IDS.length = 0;
    __content_results = null;
  };

  /**
   * 收集定投
   * @param {String} wrap
   */
  DirectPromo.prototype.collect = function(wrap) {
    var els  = util.selector('J_DirectPromo', wrap);

    S.each(els, function(el) {
      var id = el.getAttribute('data-resid');
      IDS.push(id);
      util.removeClass(el, 'J_DirectPromo');
    });
  };

  /**
   * 拼装请求
   * @return {String}
   */
  DirectPromo.prototype.makeUrl = function() {
    return API + '?resourceIds=' + IDS.join(',') + '&t=' + S.now();
  };

  /**
   * 图片预载
   * @param {Array} item
   */
  DirectPromo.prototype.loadImg = function(item) {
    var self = this;

    if (RE_PIC.test(item.content)) {
      var img  = new Image();

      img.onload = function () {
        img.onload = null;
        self.emit('tb_index_direct_promo', {
          id  : item.id,
          type: 'image',
          time: new Date()
        });
      };

      img.src = item.content;
    }
  };

  /**
   * 获取数据
   */
  DirectPromo.prototype.getData = function() {
    var self = this,
        url  = self.makeUrl();

    S.getScript(url, function() {
      __content_results && self.setData(__content_results, self.setCont);
    });
  };

  /**
   * 设置数据
   * @param {Array}    items
   * @param {Function} cb
   */
  DirectPromo.prototype.setData = function(items, cb) {
    var self = this;

    S.each(items, function(item) {
      item.content != "http://tms.tms.tms" && cb.call(self, item);
    });
  };

  /**
   * 填充内容
   * @param {Object} item
   */
  DirectPromo.prototype.setCont = function(item) {
    var self = this,
        html = null,
        id   = parseInt(item.id),
        cont = item.content,
        link = item.link,
        el   = document.getElementById('J_DirectPromo_' + id),
        spm  = null;

    if (!el) {
      S.later(function() {
        self.setCont(item);
      }, 100);
      return;
    }

    if (RE_PIC.test(cont)) {
      // 统计图片加载时间
      FEELING_LUCK && self.loadImg(item);

      // 判断是否延时加载
      if (S.inArray(id, IDS_LAZY)) {
        // 添加延时标识
        util.addClass(el, 'J_DirectPromoLazy');
        // 添加图片地址
        el.setAttribute('data-cont', cont);
        el.setAttribute('data-link', link);
        // 直接 return
        return
      }

      // 优先加载Q75品质
      RE_JPG.test(cont) && S.inArray(id, IDS_Q75) && (cont += '_q75');

      // 拼装图片加载路径
      html = '<img src="' + cont + '" />';

      // 兼容 SPM 第四位
      var linkEl = el.getElementsByTagName('a');
      if (linkEl && linkEl.length === 1) {
        spm = linkEl[0].getAttribute('data-spm');
        spm && (spm = 'data-spm="' + spm  + '"');
      }
    } else if (RE_URL.test(cont)) {
      link = null;
      html = '<iframe src="' + cont + '" scrolling="no" frameborder="0" width="330" height="200"></iframe>';
    } else {
      html = cont || '';
    }

    link ? html = '<a href="' + link + '"' + (spm || '') + 'target="_blank">' + html + '</a>' : '';

    el.innerHTML = html;
  };

  /**
   * 黄金矿工
   * @param {String} id
   * @param {Object} args
   */
  DirectPromo.prototype.emit = function(id, args) {
    args['time'] = args['time'] - g_config.startDate;
    (window.goldlog_queue || (window.goldlog_queue = [])).push({
      action   : 'goldlog.emit',
      arguments: [id, args]
    });
  };

  /**
   * 提升品质
   */
  DirectPromo.prototype.improve = function() {
    S.each(IDS_Q75, function(id) {
      var el    = document.getElementById('J_DirectPromo_' + id),
          imgEl = el.getElementsByTagName('img'),
          src   = imgEl[0].getAttribute('src');

      RE_Q75.test(src) && imgEl[0].setAttribute('src', src.substring(0, src.length - 4));
    });
  };

  /**
   * 延时加载
   * @param {Object} area
   */
  DirectPromo.prototype.lazyLoad = function(area) {
    var self = this,
        els  = util.selector('J_DirectPromoLazy', area);

    S.each(els, function(el) {
      var id    = el.getAttribute('data-resid'),
          cont  = el.getAttribute('data-cont'),
          link  = el.getAttribute('data-link'),
          index = S.indexOf(parseInt(id), IDS_LAZY);

      // 剔除列队
      IDS_LAZY.splice(index, 1);
      // 去除标识
      util.removeClass(el, 'J_DirectPromoLazy');
      // 加载定投
      self.setCont({
        id     : id,
        content: cont,
        link   : link
      });
    });
  };

  FP.directPromo = new DirectPromo();

  //初始化全页面的定投
  FP.directPromo.render();

})(KISSY);