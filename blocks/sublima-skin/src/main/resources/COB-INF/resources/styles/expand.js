
function getElementsByClassName(cl) {
var retnode = [];
var myclass = new RegExp('\\b'+cl+'\\b');
var elem = document.getElementsByTagName('*');
for (var i = 0; i < elem.length; i++) {
var classes = elem[i].className;
if (myclass.test(classes)) retnode.push(elem[i]);
}
return retnode;
};

function showHide(elementclass){
 	var myEls = getElementsByClassName(elementclass);
	for ( i=0;i<myEls.length;i++ ) {

		if (myEls[i].style.display == 'none'){
			myEls[i].style.display = '';
		} else {
			myEls[i].style.display = 'none';
	}

	if (document.getElementById("innerMidCol")) {
	  var height = document.getElementById("innerMidCol").offsetHeight;
	  var colmidleft = document.getElementById("colmidleft");
	  if (height > 500) {
	    colmidleft.style.height = height + 'px';
	  }
	  else {
	    colmidleft.style.height = height +'px';
	  }
	 
	}
	}
}
function checkExpandComment() {

  if (document.getElementById("commenterror")) {
    var commenterrorDiv = document.getElementById("commenterror");
    if (commenterrorDiv.firstChild.attributes == null) {
      if (document.getElementById("commentDiv")) {
        var commentDiv = document.getElementById("commentDiv");
        commentDiv.style.display = "none";
      }
      var test = 'asdasf';
    }
    var test2 = 'asdasf';
  }

}
