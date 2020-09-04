$(function () {
  $(document).on("touchend, mouseup", ".c-js__not-like", function (e) {
    e.preventDefault();
    e.stopPropagation();
    e.stopImmediatePropagation();
    $.ajax({
      type: "get",
      url: "/likes/create",
      dataType: "json",
    }).done(function (result) {
      insertHTML = reviewHTML(result, "like", "review");
      $(".c-review-" + result.chord.id)
        .find(".c-js__not-like")
        .remove();
      $(".c-review-" + result.chord.id).append(insertHTML);
    });
    return false;
  });

  function reviewHTML(result, review_type, review_or_not) {
    var class_name = "c-js__";
    if (review_or_not == "review") {
      class_name += "";
    } else if (review_or_not == "not") {
      class_name += "not-";
    }
    class_name += review_type;
    var html = `<a class='c-review__link ${class_name}' data-remote='true' rel='nofollow' data-method='delete' href='/${review_type}s/${result.id}?chord_id=${result.chord.id}'><div class='c-review__btn c-review__btn--red c-js__review'><div class='c-review__icon'><i class='fas fa-heart'></i></div><div class='c-review__amount'><%= ${result.chord.likes_count}</div><div class='c-review__text'>信頼できる!</div></div></a>`;
    return html;
  }
});
