$(function() {
  var update_recipe_index = function() {
    $.get($("#search_form").attr("action"), $("#search_form").serialize(), null, "script");
    return false;
  };

  $("#search_form input").keyup(update_recipe_index);
  $("#search_form .genre-filter .select-items").click(update_recipe_index);

  update_recipe_index();
});

var searchBar = document.getElementById("search-bar");
var topSpacer = document.getElementById("top-spacer");
var stickyHeight = searchBar.offsetTop;

// Add the sticky class to the header when you reach its scroll position. Remove "sticky" when you leave the scroll position
window.onscroll = function() {
  if (window.pageYOffset > stickyHeight) {
    searchBar.classList.add("sticky");
    topSpacer.classList.add("sticky-spacer");
  } else {
    searchBar.classList.remove("sticky");
    topSpacer.classList.remove("sticky-spacer");
  }
};