$(function () {
  // when users click attribute btn, it changes own color
  $(".c-js__attribute-btn").on("touchend, mouseup", function () {
    if ($(this).find(".c-js__value").prop("checked") == 0) {
      $(this).addClass("u-js__attribute-color");
    } else {
      $(this).removeClass("u-js__attribute-color");
    }
  });

  // for icon refer what attributes is users set "on"
  function checked_color(element) {
    if ($(element).find(".c-js__value").prop("checked") == 1) {
      $(element).addClass("u-js__attribute-color");
    } else {
      $(element).removeClass("u-js__attribute-color");
    }
  }

  $(document).ready(function () {
    $(".c-js__attribute-btn").each(function (i, element) {
      checked_color(element);
    });
  });

  // for icon refer what attributes is song has
  function icon_color() {
    $(".c-js__attribute-state").each(function (i, element) {
      if ($(element).attr("value") == "true") {
        $(element).parent().addClass("u-js__attribute-color");
      }
    });
  }

  $(document).ready(function () {
    icon_color();
  });
});
