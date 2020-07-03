// c-js__like
$(function () {
  // when user selects btn, make btn colored
  $(".p-search-result__sort-btn").on("touchend, mouseup", function () {
    change_sort_color($(this));
  });

  // when page reloads, make btn colored
  $(document).ready(function () {
    var btn = $("input[name= 'sort']:checked").parent();
    change_sort_color(btn);
  });

  function change_sort_color(btn) {
    // if selected-btn isn't colored
    if ($(btn).hasClass("u-js__sort-color") == false) {
      $(".p-search-result__sort-btns")
        .find(".u-js__sort-color")
        .removeClass("u-js__sort-color");
      $(btn).addClass("u-js__sort-color");
    } else {
    }
  }
});
