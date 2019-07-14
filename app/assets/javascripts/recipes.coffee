# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

genre_dropdown = document.getElementsByClassName("genre-selector").item(0)
recipe_header = document.getElementsByClassName("recipe").item(0)
genre_dropdown.oninput = () -> recipe_header.className = "recipe genre-" + genre_dropdown.value

