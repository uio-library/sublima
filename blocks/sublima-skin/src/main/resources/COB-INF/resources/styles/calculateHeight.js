function calculateDivHeight() {
  if (document.getElementById("content")) {
      var height = document.getElementById("content").clientHeight;
      var innerHeightCenter = document.getElementById("innerMidCol").clientHeight;
          
      var colmidleft = document.getElementById("colmidleft");
      if (height > innerHeightCenter) {
          colmidleft.style.height = height + 'px';
      } else {
        colmidleft.style.height = innerHeightCenter + 'px';
      }
  }
 }