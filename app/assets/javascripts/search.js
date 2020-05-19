$(function () {
  // アクションで生成されたデータをviewに反映する
  function viewResult(result) {
    if (result.chord_text.length > 0) {
      var html = `<a href="/songs/${
        result.id
      }"><div class="search-result__song-info">タイトル: ${
        result.title
      }, <div class="search-result__first-chord">${
        result.chord_text[result.chord_text.length - 1].text
      }</div></a>`;
    } else {
      var html = `<a href="/songs/${result.id}"><div class="search-result__song-info">タイトル: ${result.title}, スタンダード曲？: ${result.standard}</div>    <div class="search-result__first-chord">コードが登録されていません</div></a>`;
    }

    return html;
  }
  // フォームを送信する関数
  function sendForm() {
    // 検索ページがincremental_text。コード登録画面が#search_song_name
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

  // コード作成画面用 曲検索
  function songCandidate(result) {
    var html = `<div class="search-result__song-candidate", data-song_id="${result.id}">${result.title}</div>`;
    return html;
  }

  $("#search_song_name").on("keyup", function () {
    var input = $("#search_song_name").val();
    if (input == "") {
      $(".content__search-result").empty();
      return;
    }
    $.ajax({
      type: "get",
      url: "/songs/search",
      data: {
        keyword: input,
      },
      dataType: "json",
    }).done(function (results) {
      $(".content__search-result").empty();
      var insertHTML = "";

      $.each(results, function (i, result) {
        insertHTML += songCandidate(result);
        if (i == 4) return false;
      });

      $(".content__search-result").append(insertHTML);
    });
  });

  $(document).on(
    "touchend mouseup",
    ".search-result__song-candidate",
    function () {
      var song_id = $(this).data("song_id");
      var song_name = $(this).text();
      $("#selected_song_id").val(song_id);
      $("#search_song_name").val(song_name);
      $(".content__search-result").empty();
    }
  );
  // チューニング作成画面用 楽器検索
  function instrumentCandidate(result) {
    var html = `<div class="search-result__instrument-candidate", data-instrument_id="${result.id}", data-instrument_string="${result.total_string}">${result.name}</div>`;

    return html;
  }
  function stringForm(i) {
    var html = `<div class="strings__string">
    <input value="${i}" type="hidden" name="[tunings_attributes][${
      i - 1
    }][string_num]" id="_tunings_attributes_${i - 1}_string_num">
    <input placeholder="string${i}" type="text" name="[tunings_attributes][${
      i - 1
    }][note_name]" id="_tunings_attributes_${i - 1}_note_name">
    </div>`;

    return html;
  }

  $("#search_instrument_name").on("keyup", function () {
    var input = $("#search_instrument_name").val();
    if (input == "") {
      $(".content__search-result").empty();
      return;
    }
    $.ajax({
      type: "get",
      url: "/instruments/search",
      data: {
        keyword: input,
      },
      dataType: "json",
    }).done(function (results) {
      $(".content__search-result").empty();
      var insertHTML = "";

      $.each(results, function (i, result) {
        insertHTML += instrumentCandidate(result);
        if (i == 4) return false;
      });

      $(".content__search-result").append(insertHTML);
    });
  });
  $(document).on(
    "touchend mouseup",
    ".search-result__instrument-candidate",
    function () {
      var instrument_id = $(this).data("instrument_id");
      var instrument_string = $(this).data("instrument_string");
      var instrument_name = $(this).text();
      $("#selected_instrument_id").val(instrument_id);
      $("#search_instrument_name").val(instrument_name);

      $(".content__search-result").empty();
      $(".content__strings").empty();

      var insertHTML = "";
      var i = 1;
      for (i = 1; i <= instrument_string; i++) {
        insertHTML += stringForm(i);
      }

      $(".content__strings").append(insertHTML);
    }
  );
});
