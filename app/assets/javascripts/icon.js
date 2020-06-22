$(function () {
  $(".c-js__attribute-btn").on("touchend, mouseup", function () {
    if ($(this).hasClass("u-js__attribute-color") == 0) {
      $(this).addClass("u-js__attribute-color");
    } else {
      $(this).removeClass("u-js__attribute-color");
    }
  });

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
