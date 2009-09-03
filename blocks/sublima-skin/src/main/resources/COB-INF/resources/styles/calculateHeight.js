function calculateDivHeight() {
  if (document.getElementById("content")) {
      var height = document.getElementById("content").clientHeight;
      var innerHeightCenter = document.getElementById("innerMidCol").clientHeight;
      var innerHeightLeft = document.getElementById("colleft").clientHeight;
          
      var colmidleft = document.getElementById("colmidleft");
      if (height > innerHeightCenter) {
          if (height > innerHeightLeft) { 
            colmidleft.style.height = height + 'px';
          }else{
            colmidleft.style.height = innerHeightLeft + 'px';
          }
      } else {
        if(innerHeightCenter > innerHeightLeft){
            colmidleft.style.height = innerHeightCenter + 'px';
        }else{
            colmidleft.style.height = innerHeightLeft + 'px';
        }
        
       
      }
  }
 }