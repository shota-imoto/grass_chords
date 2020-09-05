$(function () {
  // コード作成画面用 曲検索
  function songCandidate(result) {
    var html = `<div class="c-song-candidate__list", data-song_id="${result.id}">${result.title}</div>`;
    return html;
  }

  $(".c-js__song-candidate").on("keyup", function () {
    var input = $(this).val();
    $(".c-song-candidate__lists").addClass("u-display__hidden");
    if (input == "") {
      $("#selected_song_id").val("");
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
      var insertHTML = "";

      if (results.length == 0) {
        $(".c-song-candidate__lists").addClass("u-display__hidden");

        return;
      }

      $.each(results, function (i, result) {
        insertHTML += songCandidate(result);
        if (i == 4) return false;
      });
      $(".c-song-candidate__lists").removeClass("u-display__hidden");

      // if user input text too quickly, before 1st ajax communication hasn't conpleted, 2nd ajax communication has started.
      // if 2nd communication finish empty process before 1st communication finishe append process, both of their results is shown at the same time.
      // so i wrote under below, in order to control this phenomenon.
      setTimeout(function () {
        $(".c-song-candidate__lists").empty();
        $(".c-song-candidate__lists").append(insertHTML);
      }, 8);
    });
  });

  // 楽曲の選択
  $(document).on("touchend, mouseup", ".c-song-candidate__list", function () {
    var song_id = $(this).data("song_id");
    var song_name = $(this).text();
    $("#selected_song_id").val(song_id);
    $("#search_song_name").val(song_name);
    $(".c-song-candidate__lists").empty();
    $(".c-song-candidate__lists").addClass("u-display__hidden");
  });

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

  // 楽曲インクリメンタルサーチ
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

  //地域選択パレットを開く
  $(".p-search-user__place-open").on("touchend, mouseup", function () {
    $(".p-search-user__place-wrapper").show();
    $(".p-search-user__close-layer").show();
  });

  // 地域選択パレットを閉じる
  $(document).on(
    "touchend mouseup",
    ".p-search-user__close-layer",
    function () {
      $(".p-search-user__place-wrapper").hide();
      $(".p-search-user__close-layer").hide();
    }
  );

  // 選択した地域を表示する
  $('[name="places[]"]').change(function () {
    var selected_places = $('input[name="places[]"]:checked')
      .map(function () {
        return $(this).next().text();
      })
      .get();

    var selected_places_text = selected_places.join(", ");
    $(".p-search-user__place-selected").text("地域: " + selected_places_text);
  });
});
