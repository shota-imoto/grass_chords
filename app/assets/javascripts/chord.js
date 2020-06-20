$(function () {
  // カーソル表示
  $(".c-chordunit").on("touchend mouseup", function () {
    $(".c-chordunit").removeClass("cursor");
    var id = $(this).attr("id");
    $("#" + id).addClass("cursor");

    // when user selects chordunit, load input text and indicate it.
    input_text_display(id);
  });

  // エディター表示・非表示処理
  $(".content__editer-btn").on("touchend mouseup", function () {
    $(".content__chord-btns").removeClass("hidden");
  });

  $(".chord-btns__close").on("touchend mouseup", function () {
    $(".content__chord-btns").addClass("hidden");
  });

  // 入力処理
  $(document).on("touchend, mouseup", ".chord-btns--command", function () {
    var input = $(this).text();

    if ($(".cursor").length == 0) return false;

    var id = $(".cursor").attr("id");
    id = id.replace("unit_0-", "");

    // if some of command duplicates, under below judge statement resolves this problem.
    if ($(this).hasClass("c-js__chord-editor-duplication")) {
      if (input == "B") input = "sharp";
      else if (input == "'") input = "rbar";
    }

    // 入力コマンドに変換
    if (input == "sharp") input_text(id, "s");
    else if (input == "7th") input_text(id, "7");
    else if (input == "{") selected_text_edit("leftbar", id, "{");
    else if (input == "}") selected_text_edit("rightbar", id, "}");
    else if (input == "'") selected_text_edit("leftbar", id, "'");
    else if (input == "rbar") selected_text_edit("rightbar", id, "'");
    else if (input == "@") selected_text_edit("beat", id, "@");
    else if (input == "$") selected_text_edit("beat", id, "$");
    else if (input == "#") selected_text_edit("beat", id, "#");
    else if (input == "くり返し") input_text(id, "‘");
    else if (input == "BackSpace") {
      delete_text(id);
    } else {
      input_text(id, input);
    }
  });

  // 楽譜記号の処理(共通)
  function selected_text_edit(unit_name, id, input) {
    if ($(".cursor > .c-chordunit__" + unit_name).text() == input) {
      $(".cursor > .c-chordunit__" + unit_name).text("");
    } else {
      $(".cursor > .c-chordunit__" + unit_name).text("");
      $(".cursor > .c-chordunit__" + unit_name).text(input);
    }

    $(".cursor > #chord_chordunits_attributes_" + id + "_" + unit_name).val(
      $(".cursor > .c-chordunit__" + unit_name).text()
    );
  }

  // 音名の入力処理
  function input_text(id, letter) {
    var text_value = $("#chord_chordunits_attributes_" + id + "_text").val();

    text_value = text_value + letter;
    $("#chord_chordunits_attributes_" + id + "_text").val(text_value);
    var unit_id = $(".cursor").attr("id");
    text_display(unit_id, text_value);
  }

  // 音名の削除処理
  function delete_text(id) {
    var text_value = $("#chord_chordunits_attributes_" + id + "_text").val();
    text_value = text_value.slice(0, -1);
    $("#chord_chordunits_attributes_" + id + "_text").val(text_value);
    var unit_id = $(".cursor").attr("id");
    text_display(unit_id, text_value);
  }

  // 音名の表示処理(入力・削除共通)
  function text_display(unit_id, letter) {
    const note_name_array = ["G", "A", "B", "C", "D", "E", "F", "‘"];
    const half_note_array = ["s", "b"];
    const minor_note_array = ["m"];

    // クリア操作
    $("#" + unit_id + " > .c-chordunit__note > .c-chordunit__note-name").text(
      ""
    );
    $("#" + unit_id + " > .c-chordunit__note > .c-chordunit__half-note").text(
      ""
    );
    $("#" + unit_id + " > .c-chordunit__note > .c-chordunit__modifier").text(
      ""
    );

    // データ処理用に文字列→配列変換
    var letter_array = letter.split("");
    var i = 0;

    // 音名処理、１列目に存在するときのみ反映
    if (note_name_array.includes(letter_array[i])) {
      if (letter_array[i] == "‘") {
        var html = `<span class="font_repeat">‘</span>`;
        $(
          "#" + unit_id + " > .c-chordunit__note > .c-chordunit__note-name"
        ).append(html);
      } else {
        $(
          "#" + unit_id + " > .c-chordunit__note > .c-chordunit__note-name"
        ).text(letter_array[i]);
      }
      i = 1;

      // 半音処理。２列目に存在するときのみ反映
      if (half_note_array.includes(letter_array[i])) {
        var display_letter;
        if (letter_array[i] == "s") display_letter = "B";
        else display_letter = letter_array[i];

        $("#" + unit_id)
          .find(".c-chordunit__half-note")
          .text(display_letter);

        i = 2;
      }
      // マイナー処理、2列目以降に存在するときに一度だけ反映
      if (minor_note_array.includes(letter_array[i])) {
        $("#" + unit_id)
          .find(".c-chordunit__modifier")
          .text(letter_array[i]);
        i = i + 1;
      }
      // その他の処理。基本的に全てそのまま反映する。例外処理は随時追加。
      for (i; i < letter_array.length; i++) {
        // 7th処理
        if (letter_array[i] == "7") {
          var display_letter = $("#" + unit_id)
            .find(".c-chordunit__modifier")
            .text();

          display_letter = display_letter + letter_array[i];
          $("#" + unit_id)
            .find(".c-chordunit__modifier")
            .text(display_letter);
        }
      }
    } else {
      // １文字目に音名が存在しない場合は動作なし
    }
    input_text_display(unit_id);
  }

  function input_text_display(unit_id) {
    $(".chord-btns__text-window").text("");

    var get_input = $("#" + unit_id)
      .find(".c-chordunit__text")
      .attr("value");

    $(".chord-btns__text-window").text(get_input);
  }

  $(document).ready(function () {
    $(".c-chordunit__text").each(function (i, text) {
      var letter = $(text).attr("value");

      var chord_num = Math.floor(i / 48);
      var unit_num = i % 48;

      if (letter != undefined) {
        letter = letter.trim();

        text_display("unit_" + chord_num + "-" + unit_num, letter);
      }
    });
  });
});
