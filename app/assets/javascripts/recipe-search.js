$(function() {
  var update_recipe_index = function() {
    $.get($("#search_form").attr("action"), $("#search_form").serialize(), null, "script");
    return false;
  };

  $("#search_form input").keyup(update_recipe_index);
  $("#search_form .genre-filter .select-items").click(update_recipe_index);

  update_recipe_index();
});