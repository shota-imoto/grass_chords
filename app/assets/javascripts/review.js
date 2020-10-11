$(function () {
  // not-like => like
  $(document).on("touchend, mouseup", ".c-js__not-like", function () {
    var chord_class = $(this).parent().attr("class").split(" ");
    var chord_id = chord_class[1].replace("c-review-", "");

    $.ajax({
      type: "post",
      url: "/likes",
      data: {
        chord_id: chord_id,
      },
      dataType: "json",
    }).done(function (result) {
      insertHTML = reviewHTML(result, "like", "plus");

      $(".c-review-" + result.chord.id)
        .find(".c-js__not-like")
        .remove();
      $(".c-review-" + result.chord.id).append(insertHTML);
    });
  });

  // like => not-like
  $(document).on("touchend, mouseup", ".c-js__like", function () {
    var chord_class = $(this).parent().attr("class").split(" ");
    var chord_id = chord_class[1].replace("c-review-", "");
    $.ajax({
      type: "delete",
      url: "/likes/0",
      data: {
        chord_id: chord_id,
      },
      dataType: "json",
    }).done(function (result) {
      insertHTML = reviewHTML(result, "like", "minus");

      $(".c-review-" + result.chord.id)
        .find(".c-js__like")
        .remove();
      $(".c-review-" + result.chord.id).append(insertHTML);
    });
  });

  // not-practice => practice
  $(document).on("touchend, mouseup", ".c-js__not-practice", function () {
    var chord_class = $(this).parent().attr("class").split(" ");
    var chord_id = chord_class[1].replace("c-review-", "");
    $.ajax({
      type: "post",
      url: "/practices",
      data: {
        chord_id: chord_id,
      },
      dataType: "json",
    }).done(function (result) {
      if (error_hundling(result.error)) {
        return false;
      }
      console.log("returnしてない");
      insertHTML = reviewHTML(result, "practice", "plus");

      $(".c-review-" + result.chord.id)
        .find(".c-js__not-practice")
        .remove();
      $(".c-review-" + result.chord.id).prepend(insertHTML);
    });
  });

  // practice => not-practice
  $(document).on("touchend, mouseup", ".c-js__practice", function () {
    var chord_class = $(this).parent().attr("class").split(" ");
    var chord_id = chord_class[1].replace("c-review-", "");
    $.ajax({
      type: "delete",
      url: "/practices/0",
      data: {
        chord_id: chord_id,
      },
      dataType: "json",
    }).done(function (result) {
      if (error_hundling(result.error)) {
        return false;
      }
      insertHTML = reviewHTML(result, "practice", "minus");

      $(".c-review-" + result.chord.id)
        .find(".c-js__practice")
        .remove();
      $(".c-review-" + result.chord.id).prepend(insertHTML);
    });
  });

  function reviewHTML(result, review_type, plus_or_minus) {
    var class_name = "c-js__";
    var icon_color_class = "";
    var icon_type = "";
    var review_text = "";
    var review_id = "";
    var review_count = "";

    if (review_type == "like") {
      review_text += "信頼できる";
      review_count = result.chord.likes_count;
      icon_type = "fas fa-heart";
    } else if (review_type == "practice") {
      review_text += "練習してる";
      review_count = result.chord.practices_count;
      icon_type = "fas fa-lightbulb";
    }

    if (plus_or_minus == "plus") {
      class_name += "";
      icon_color_class = "c-review__btn--red";
      review_text += "!";
      review_id = `id="${result.id}"`;
    } else if (plus_or_minus == "minus") {
      class_name += "not-";
      review_text += "?";
    }

    class_name += review_type;

    var html = `<div class="${class_name} c-review__link"><div class='c-review__btn ${icon_color_class} c-js__review u-cursor__pointer'><div class='c-review__icon'><i class='${icon_type}'></i></div><div class='c-review__amount'>${review_count}</div><div class='c-review__text'>${review_text}</div></div></div>`;
    return html;
  }

  function error_hundling(error) {
    if (error) {
      console.log(error);
      $(".l-header").after('<p class="l-error__js"></p>');
      $(".l-error__js").text(error);
      return true;
    }
  }

  // delete practice at user#show view
  $(document).on("touchend, mouseup", ".c-js__practice-delete", function () {
    var chord_id = $(this).attr("id");
    $.ajax({
      type: "delete",
      url: "/practices/0",
      data: {
        chord_id: chord_id,
      },
      dataType: "json",
    }).done(function (result) {
      $(".c-js__practice-list--" + result.id).remove();
    });
  });
});
