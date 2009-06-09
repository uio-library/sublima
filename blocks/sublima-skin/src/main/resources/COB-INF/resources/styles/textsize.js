function ChangeTextSize(size, sender) {
  if (sender != null) {
    document.body.style.fontSize = size;

    document.getElementById("textSizeLarge").style.background = 'none';
    document.getElementById("textSizeMedium").style.background = 'none';
    document.getElementById("textSizeSmall").style.background = 'none';

    sender.style.background = '#c8dce6';

    var cookieSize = get_cookie('textSizeCookie');
    if (cookieSize != size) {
      set_cookie("textSizeCookie", size);
    } 
    
  } else {
  
    if (get_cookie('textSizeCookie') != 'null') {
      var cookieSize = get_cookie('textSizeCookie');
      if (cookieSize == '14px') {
        document.body.style.fontSize = cookieSize;
        document.getElementById("textSizeLarge").style.background = '#c8dce6';
        document.getElementById("textSizeMedium").style.background = 'none';
        document.getElementById("textSizeSmall").style.background = 'none';
      }
      if (cookieSize == '12px') {
        document.body.style.fontSize = cookieSize;
        document.getElementById("textSizeLarge").style.background = 'none';
        document.getElementById("textSizeMedium").style.background = '#c8dce6';
        document.getElementById("textSizeSmall").style.background = 'none';
      }
      if (cookieSize == '10px') {
        document.body.style.fontSize = cookieSize;
        document.getElementById("textSizeLarge").style.background = 'none';
        document.getElementById("textSizeMedium").style.background = 'none';
        document.getElementById("textSizeSmall").style.background = '#c8dce6';
      }
       
    }
  
   }
  
  
}

function set_cookie(name, value) {
  var cookie_string = name + "=" + escape(value);

  document.cookie = cookie_string;
}


function get_cookie(cookie_name) {
  var results = document.cookie.match('(^|;) ?' + cookie_name + '=([^;]*)(;|$)');

  if (results)
    return (unescape(results[2]));
  else
    return null;
}



