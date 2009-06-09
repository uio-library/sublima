
function OpenCloseFact(element, sender) {
  
  var e = document.getElementById(element);
  if (e.style.display == 'none') 
  {
    e.style.display = '';
    sender.src = '{$baseurl}/images/closefacet.png';
  } else 
  {
    e.style.display = 'none';
    sender.src = '{$baseurl}/images/openfacet.png';
  }

}


