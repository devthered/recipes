function updateSize(textarea) {
  textarea.style.height = ""; // clears the scrollHeight value of extra space
  textarea.style.height = (Math.min(textarea.scrollHeight)) + "px";
}

var textareas = document.getElementsByClassName("pretty-textarea");
for(var i = 0; i < textareas.length; i++)
{
  var textarea = textareas.item(i);
  textarea.oninput = function(event) {
    var textarea = document.getElementById(event.target.id);
    updateSize(textarea);
  };
  updateSize(textarea);
}