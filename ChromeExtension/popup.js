document.addEventListener('DOMContentLoaded', function () {
  var divs = document.querySelectorAll('a');
  for (var i = 0; i < divs.length; i++) {
    divs[i].addEventListener('click', function() {
      chrome.tabs.create({url: this.href});
     return false;
    });
  }
  var imgURL = chrome.extension.getURL("images/howTo.png");
  var img = document.createElement("IMG");
  img.src = imgURL;
  img.style.width = '100%';
  document.getElementById("photo").appendChild(img);
  chrome.storage.local.get({
    FBG_Active: true,
  }, function(items) {
    addButton(items.FBG_Active)
  });
});

function addButton (active) {
  button = document.getElementById("toggle");
  button.style.float = 'right';

  updateText(button, active);
  button.addEventListener("click", function () {
    active = !active;
    updateText(button, active);
    chrome.storage.local.set({ FBG_Active: active })
  });
}

function updateText (button, active) {
  console.log(button);
  if (active) button.innerHTML = 'Turn Off FB Graffiti';
  else button.innerHTML = 'Turn On FB Graffiti';
}