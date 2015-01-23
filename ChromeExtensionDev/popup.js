document.addEventListener('DOMContentLoaded', function () {
  var divs = document.querySelectorAll('a');
  for (var i = 0; i < divs.length; i++) {
    divs[i].addEventListener('click', function() {
      chrome.tabs.create({url: this.href});
     return false;
    });
  }
  var imgURL = chrome.extension.getURL("images/throwingMice.png");
  var img = document.createElement("IMG");
  img.src = imgURL;
  img.style.position = "absolute";
  img.style.top = "35px";
  img.style.left = "180px";
  var width = Math.floor(370/3);
  var height = Math.floor(400/3);
  img.style.width = width+"px";
  img.style.height = height+"px";
  document.body.appendChild(img);
});