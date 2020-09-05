$(function () {
  // when user selects btn, make btn colored
  $(".c-js__attribute-btn").on("change", function () {
    checked_color(this);
  });

  // when page reloads, make btn colored
  $(document).ready(function () {
    $(".c-js__attribute-btn").each(function (i, element) {
      checked_color(element);
    });
  });

  function checked_color(element) {
    if ($(element).find(".c-js__value").prop("checked") == true) {
      $(element).addClass("u-js__attribute-color");
    } else {
      $(element).removeClass("u-js__attribute-color");
    }
  }

  // for icon refer what attributes is song has
  function icon_color(element) {
    if ($(element).attr("value") == "true") {
      $(element).parent().addClass("u-js__attribute-color");
    }
  }

  function icon_colors() {
    $(".c-js__attribute-state").each(function (i, element) {
      icon_color(element);
    });
  }

  $(document).ready(function () {
    icon_colors();
  });
});
