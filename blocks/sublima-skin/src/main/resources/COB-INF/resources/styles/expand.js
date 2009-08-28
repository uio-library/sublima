function hideFacetsOnLoad() {
  var maxFacets = 6;
  
  var publisherFacet = getElementsByClassName("publisherFacet");
  if (publisherFacet.length > maxFacets) {
    hidefacets("publisherFacet");
  }else {
    document.getElementById("publisherFacetHideShow").style.display = 'none';
  }

  var languageFacet = getElementsByClassName("languageFacet");
  if (languageFacet.length > maxFacets) {
    hidefacets("languageFacet"); 
  }else {
  document.getElementById("languageFacetHideShow").style.display = 'none';
  }
  
  var audienceFacet = getElementsByClassName("audienceFacet");
  if (audienceFacet.length > maxFacets) {
    hidefacets("audienceFacet");
  } else {
    document.getElementById("audienceFacetHideShow").style.display = 'none';
  }

  var subjectFacet = getElementsByClassName("subjectFacet");
  if (subjectFacet.length > maxFacets) {
    hidefacets("subjectFacet");
  } else {
    document.getElementById("subjectFacetHideShow").style.display = 'none';
  }
}


function showfacets(className) {
  var elements = getElementsByClassName(className);
  for (i = 1; i < elements.length; i++) {
    elements[i].style.display = 'block';
  }
  document.getElementById(className + "ShowLink").style.display = 'none';
  document.getElementById(className + "HideLink").style.display = 'block';
}

function hidefacets(className) {
  var maxFacets = 6;
  var elements = getElementsByClassName(className);
  for (i = 1; i < elements.length; i++) {
    if (i >= maxFacets) {
      elements[i].style.display = 'none';
    }
  }
  document.getElementById(className + "ShowLink").style.display = 'block';
  document.getElementById(className + "HideLink").style.display = 'none';
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
