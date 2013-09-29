(function(){
  (function(){
    if (get_top_domain(document.referrer) == get_top_domain(location.hostname)) return;
    var params = get_params();
    if(!params['utm_source']){
      params['utm_source']   = get_full_domain(document.referrer) || 'direct';
      params['utm_campaign'] = 'notset_c0';
      params['utm_medium']   = '';
      params['utm_term']     = '';
      params['utm_content']  = '';
    }
    set_cookies({
      utm_csr: params['utm_source'],
      utm_ccn: params['utm_campaign'],
      utm_cmd: params['utm_medium'], 
      utm_ctr: params['utm_term'],   
      utm_cct: params['utm_content'],
      utm_etr: entrance_type()
    });
  })();

  function entrance_type(){
    var host;
    var m;
    if(m = location.hostname.match(/^(ju|zhi)\.\w+\.com$/)){
      host = m[1];
    } else {
      host = 'tao';
    }
    var path;
    if(location.pathname == '/'){
      path = 'home';
    } else if(m = location.pathname.match(/^\/(type|tag|deal|site|welfare)(\/|$)/)){
      path = m[1];
    } else if(location.pathname.match(/^\/to\/jump\//)){
      path = 'out';
    } else {
      path = 'others';
    }
    return host + '.' + path;
  }

  function get_params(){
    var params = { };
    var tmp = location.search.slice(1);
    //tmp.replace(/^\s+|\s+$/, '');
    if(tmp.length <= 0)return params;
    tmp = tmp.split('&');
    var t;
    for(var i = 0; (t = tmp[i]) !== undefined; i++){
      var index = t.indexOf('=');
      if(index > 0){
        var name  = t.slice(0, index);
        var value = t.slice(index + 1);
      } else {
        var name  = t;
        var value = '';
      }
      params[name] = value;
    }
    return params;
  }

  function get_top_domain(url){
    var m = url.match(/^(?:\w{1,9}:\/\/)?([\w-]+\.)+(\w+)/);
    if(m)return m[1] + m[2];
    else return '';
  }

  function get_full_domain(url){
    var m = url.match(/^(?:\w{1,9}:\/\/)?(([\w-]+\.)+\w+)/);
    if(m)return m[1];
    else return '';
  }

  function set_cookies(cookies){
    var time = new Date();
    time.setDate(time.getDate() + 30);
    var appendix = '; domain=.' + get_top_domain(location.hostname) + '; path=/; expires=' + time.toString();
    for(var name in cookies){
      document.cookie = name + '=' + (cookies[name] || '') + appendix;
    }
  }
})();

