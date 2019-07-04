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

var genre_dropdown = document.getElementsByClassName("genre-selector").item(0);
var recipe_header = document.getElementsByClassName("recipe").item(0);
genre_dropdown.oninput = function() {
  recipe_header.className = "recipe genre-" + genre_dropdown.value;
};