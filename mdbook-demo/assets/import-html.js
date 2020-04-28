(function() {
  var w = window;
  var req = function(url, callback, type, query) {
    if (!type) {
      type = "GET";
    }
    var request =
      "undefined" !== typeof w.XDomainRequest
        ? w.XDomainRequest
        : w.XMLHttpRequest;
    if (!request) {
      return false;
    }
    var oReq = new request();
    if ("function" === typeof callback) {
      oReq.onload = function() {
        callback(oReq.responseText);
      };
    }
    oReq.open(type, url);
    oReq.send(query);
    return true;
  };
  var queryOne = function(sel) {
    return w.document.querySelector(sel);
  };
  var queryEl = function(el) {
    return "string" === typeof el ? queryOne(el) : el;
  };
  w.importHtml = function(dom, url) {
    var el = queryEl(dom);
    req(url, function(html) {
      el.innerHTML = html;
    });
  };
  var attrName = "data-import";
  var doms = document.querySelectorAll("[" + attrName + "]");
  for (var i = 0, j = doms.length; i < j; i++) {
    var dom = doms[i];
    importHtml(dom, dom.getAttribute(attrName));
  }
})();
