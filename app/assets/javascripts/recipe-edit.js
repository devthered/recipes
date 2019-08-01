$(".recipe").click(function() {
  $(".recipe").attr("class", "recipe genre-" + $(".select-selected").html().replace(" ", "-"));
});