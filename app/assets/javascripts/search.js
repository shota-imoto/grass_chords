$(function () {
  // アクションで生成されたデータをviewに反映する
  function viewResult(result) {
    if (result.chord_text.length > 0) {
      var html = `<div class="search-result__song-info">タイトル: ${
        result.title
      }, スタンダード曲？: ${result.standard}</div>
    <div class="search-result__first-chord">${
      result.chord_text[result.chord_text.length - 1].text
    }</div>`;
    } else {
      var html = `<div class="search-result__song-info">タイトル: ${result.title}, スタンダード曲？: ${result.standard}</div>    <div class="search-result__first-chord">コードが登録されていません</div>`;
    }

    return html;
  }
  // フォームを送信する関数
  function sendForm() {
    var input = $("#incremental_text").val();
    var jam = $("#jam").prop("checked");
    var standard = $("#standard").prop("checked");
    var beginner = $("#beginner").prop("checked");
    $.ajax({
      type: "get",
      url: "/songs/search",
      data: {
        keyword: input,
        jam: jam,
        standard: standard,
        beginner: beginner,
      },
      dataType: "json",
    }).done(function (results) {
      $(".search-results__search-result").empty();
      var insertHTML = "";
      $.each(results, function (i, result) {
        insertHTML += viewResult(result);
      });
      $(".search-results__search-result").append(insertHTML);
    });
  }
  // 検索フォームにキーワードが入力されたときに発火
  $("#incremental_text").on("keyup", sendForm);
  // チェックボックスの状態が変化したときに発火
  $("#incremental_jam").change(sendForm);
  $("#incremental_standard").change(sendForm);
  $("#incremental_beginner").change(sendForm);
});
