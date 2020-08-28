$(function () {
  // キー選択パレットの表示・非表示
  //キー選択パレットを開く
  $(".c-key-change__display").on("touchend, mouseup", function () {
    $("#chord-menu").show();
    $(".c-key-change__close-layer").show();

    $(".wrapper").append(`<div class="clear_overlay"></div>`);
  });

  // キー選択パレットを閉じる
  $(document).on(
    "touchend mouseup",
    ".c-key-change__close-layer, .c-key-change__close",
    function () {
      $("#chord-menu").hide();
      $(".c-key-change__close-layer").hide();
    }
  );

  // 現在キーの表示切替
  $(".c-key-change__btn--note").on("touchend, mouseup", function () {
    var selected = $(this).text().trim();
    var key_state = $(".key-display--form").attr("value");
    const absolute_note_array = [
      "G",
      "GB",
      "A",
      "Bb",
      "B",
      "C",
      "CB",
      "D",
      "Eb",
      "E",
      "F",
      "FB",
      "G",
    ];

    key_state = key_state.replace("m", "");
    var key_index = absolute_note_array.indexOf(key_state);

    $(".c-key-change__present ").text("key of " + selected);
    $(".key-display--form").attr("value", selected);
    if ($(".c-js__key-change").hasClass("c-js__able")) key_change(key_index);
  });

  // #/b
  $(".c-key-change__btn--half").on("touchend, mouseup", function () {
    var selected = $(this).text().trim();
    var key_state = $(".key-display--form").attr("value");

    // マイナー記号を削除する
    key_state = key_state.replace("m", "");

    const absolute_note_array = [
      "G",
      "GB",
      "A",
      "Bb",
      "B",
      "C",
      "CB",
      "D",
      "Eb",
      "E",
      "F",
      "FB",
      "G",
    ];

    var key_index = absolute_note_array.indexOf(key_state);
    var new_index = 0;

    if (selected == "B") {
      new_index = key_index + 1;
    } else {
      new_index = key_index - 1;
      if (new_index == -1) new_index = new_index + 12;
    }

    key_state = absolute_note_array[new_index];

    $(".key-display--form").attr("value", key_state);

    if (key_state.length == 2) {
      $(".c-key-change__present").text("key of " + key_state.charAt(0));
      $(".c-key-change__present").append(
        `<span class="font_base-key c-font__base">${key_state.charAt(1)}</span>`
      );
    } else {
      $(".c-key-change__present").text("key of " + key_state);
    }

    if ($(".c-js__key-change").hasClass("c-js__able")) key_change(key_index);
  });

  // m
  $(".c-key-change__btn--modifier").on("touchend, mouseup", function () {
    var key_state = $(".key-display--form").attr("value");
    if (key_state.indexOf("m") == -1) {
      $(".c-key-change__present ").append(
        `<span class="c-js__key-change--minor">m</span>`
      );
      key_state = key_state + "m";
      $(".key-display--form").attr("value", key_state);
    }
  });

  function key_change(before_key_index) {
    const absolute_note_array = [
      "G",
      "GB",
      "A",
      "Bb",
      "B",
      "C",
      "CB",
      "D",
      "Eb",
      "E",
      "F",
      "FB",
      "G",
    ];

    var key_state = $(".key-display--form").attr("value");

    key_state = key_state.replace("m", "");

    var now_key_index = absolute_note_array.indexOf(key_state);
    var key_difference = now_key_index - before_key_index;
    $(".c-chordunit__note").each(function (i, value) {
      var note = $(value).children(".c-chordunit__note-name").text();
      note = note + $(value).children(".c-chordunit__half-note").text();

      // 異常表記または別表記を変換する
      if (note == "Ab") {
        note = "GB";
      } else if (note == "AB") {
        note = "Bb";
      } else if (note == "BB") {
        note = "C";
      } else if (note == "Cb") {
        note = "B";
      } else if (note == "DB") {
        note = "Eb";
      } else if (note == "EB") {
        note = "F";
      } else if (note == "Fb") {
        note = "E";
      } else if (note == "Gb") {
        note = "FB";
      } else {
      }

      // 繰り返し記号は↓のどこにも当てはまらないためindexOfを用いたときに-1となる
      // if (note == "") note_index = "blank";
      // else if (note == "‘") note_index = "repeat_symbol";
      // else  {
      //   note_index = absolute_note_array.indexOf(note);
      //   note_index = note_index + key_difference;
      //   if (note_index > 12) note_index = note_index - 12;
      //   else if (note_index < 0) note_index = note_index + 12;
      //   note = absolute_note_array[note_index];
      // }

      note_index = absolute_note_array.indexOf(note);

      if (note_index != -1) {
        // 階名の場合
        note_index = note_index + key_difference;
        if (note_index > 12) note_index = note_index - 12;
        else if (note_index < 0) note_index = note_index + 12;
        note = absolute_note_array[note_index];
      } else {
        // 階名ではない場合
        note_index = "no_action";
      }

      if (note_index == "no_action");
      else if (note.length == 2) {
        $(value).children(".c-chordunit__note-name").text(note.charAt(0));
        $(value).children(".c-chordunit__half-note").text(note.charAt(1));
      } else if (note.length == 1) {
        $(value).children(".c-chordunit__note-name").text(note.charAt(0));
        $(value).children(".c-chordunit__half-note").text("");
      } else {
      }
    });
  }
});
