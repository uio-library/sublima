function hideFacetsOnLoad() {
  var maxFacets = 10;
  
  var publisherFacet = getElementsByClassName("publisherFacet");
  if (publisherFacet != null) {
      if (publisherFacet.length > maxFacets) {
          hidefacets("publisherFacet");
      } else {
          var el = document.getElementById("publisherFacetHideShow");
          if (el != null) {
              el.style.display = 'none';
          }
      }
  }

  var languageFacet = getElementsByClassName("languageFacet");
  if (languageFacet != null) {
      if (languageFacet.length > maxFacets) {
          hidefacets("languageFacet");
      } else {
          var el = document.getElementById("languageFacetHideShow");
          if (el != null) {
              el.style.display = 'none';
          }
      }
  }

  var audienceFacet = getElementsByClassName("audienceFacet");
  if (audienceFacet != null) {
      if (audienceFacet.length > maxFacets) {
          hidefacets("audienceFacet");
      } else {
          var el = document.getElementById("audienceFacetHideShow");
          if (el != null) {
              el.style.display = 'none';
          }

      }
  }
  

  var subjectFacet = getElementsByClassName("subjectFacet");
  if (audienceFacet != null) {
      if (subjectFacet.length > maxFacets) {
          hidefacets("subjectFacet");
      } else {
          var el = document.getElementById("subjectFacetHideShow");
          if (el != null) {
              el.style.display = 'none';
          }
      }
  }
}


function showfacets(className) {
  var elements = getElementsByClassName(className);
  for (i = 1; i < elements.length; i++) {
    elements[i].style.display = 'block';
  }
  var el1 = document.getElementById(className + "ShowLink");
  if (el1 != null) {
    el1.style.display = 'none';
  }
  var el2 = document.getElementById(className + "HideLink")
  if (el2 != null) {
    el2.style.display = 'block';
}
calculateDivHeight()
}

function hidefacets(className) {
  var maxFacets = 10;
  var elements = getElementsByClassName(className);
  for (i = 1; i < elements.length; i++) {
    if (i >= maxFacets) {
      elements[i].style.display = 'none';
    }
  }
  var el1 = document.getElementById(className + "ShowLink");
  if (el1 != null) {
    el1.style.display = 'block';
  }
  var el2 = document.getElementById(className + "HideLink")
  if (el2 != null) {
    el2.style.display = 'none';
}
calculateDivHeight()
}

function getElementsByClassName(cl) {
var retnode = [];
var myclass = new RegExp('\\b'+cl+'\\b');
var elem = document.getElementsByTagName('*');
for (var i = 0; i < elem.length; i++) {
var classes = elem[i].className;
if (myclass.test(classes)) retnode.push(elem[i]);
}
return retnode;
}

function OpenCloseFact(element, sender) {

  var e = document.getElementById(element);
  if (e.style.display == 'none') {
    e.style.display = '';
    sender.src = '{$baseurl}/images/closefacet.png';
  } else {
    e.style.display = 'none';
    sender.src = '{$baseurl}/images/openFacet.png';
  }

}
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
