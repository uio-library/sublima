
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
	}
} 
