function calculateDivHeight() {
  if (document.getElementById("content")) {
    var height = document.getElementById("content").clientHeight;
    var colmidleft = document.getElementById("colmidleft");
    colmidleft.style.height = height + 'px';
  }
 }