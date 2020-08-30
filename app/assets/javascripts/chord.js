$(function () {
  // カーソル表示
  $(".c-js__cursor-marker").on("touchend, mouseup", function () {
    if (
      $(".js-judge__create-chord").length ||
      $(".js-judge__edit-chord").length
    ) {
      var id = $(this).find(".c-chordunit").attr("id");
      cursor_display(id);
      // when user selects chordunit, load input text and indicate it.
      input_text_display(id);
    }
  });

  function cursor_display(id) {
    $(".c-chordunit").removeClass("c-js__cursor");
    $("#" + id).addClass("c-js__cursor");
  }

  // 楽曲個別ページからの遷移時に曲名をあらかじめ入力しておく処理
  $(document).ready(function () {
    var song_id = $("#selected_song_id").val();

    // 新規作成(コード譜)画面でエラー発生させないため
    if (song_id == "") song_id = null;

    // コード譜編集画面以外では実行しないためのif条件文
    if (song_id != null) {
      $.ajax({
        type: "get",
        url: "/songs/id_search",
        data: {
          id: song_id,
        },
        dataType: "json",
      }).done(function (song) {
        $("#search_song_name").val(song.title);
      });
    }
  });

  // エディター表示・非表示処理
  $(".p-chord-new__editor-btn").on("touchend mouseup", function () {
    $(".c-chord-edit__wrapper--1st").removeClass("u-display__hidden");
  });

  $(".c-chord-edit__close").on("touchend mouseup", function () {
    $(".c-chord-edit__wrapper").addClass("u-display__hidden");
    // $(".c-chord-edit__wrapper").addClass("u-display__hidden");
  });

  // エディター表示切り替え処理
  function shift_editor() {
    $(".c-chord-edit__wrapper--1st").toggleClass("u-display__hidden");
    $(".c-chord-edit__wrapper--2nd").toggleClass("u-display__hidden");
  }

  // 入力処理
  $(document).on("touchend, mouseup", ".c-chord-edit__btn", function () {
    // var input = $(this).text();
    // キーボードに画像を入れ込む場合、text()が効かなくなるため、対策
    var input = $(this).find(".c-chord-edit__input").text();

    // if shift-btn is inputted, keyboard is exchanged and input operation is cancelled.
    if (input == "Shift") {
      shift_editor();
      return false;
    }
    // if cursor is off, input operation is cancelled.
    if ($(".c-js__cursor").length == 0) {
      return false;
    }
    var id = $(".c-js__cursor").attr("id");

    id = id.replace("unit_0-", "");

    if (input == "next") {
      id = Number(id) + 1;
      id = "unit_0-" + id;
      cursor_display(id);
      return false;
    }

    if (
      $(this)
        .find(".c-chord-edit__input")
        .hasClass("c-js__chord-editor-duplication")
    ) {
      // if some of command duplicates, under below judge statement resolves this problem.
      if (input == "B") input = "sharp";
      else if (input == "'") input = "rbar";
      else if (input == '"') input = "rwbar";
    }

    // 入力コマンドに変換
    if (input == "sharp") input_text(id, "s");
    else if (input == "7th") input_text(id, "7");
    else if (input == "{") selected_text_replace("leftbar", id, "{");
    else if (input == "}") selected_text_replace("rightbar", id, "}");
    else if (input == "[") selected_text_replace("leftbar", id, "[");
    else if (input == "]") selected_text_replace("rightbar", id, "]");
    else if (input == "'") selected_text_replace("leftbar", id, "'");
    else if (input == "rbar") selected_text_replace("rightbar", id, "'");
    else if (input == '"') selected_text_replace("leftbar", id, '"');
    else if (input == "rwbar") selected_text_replace("rightbar", id, '"');
    else if (input == "@") selected_text_replace("beat", id, "@");
    else if (input == "$") selected_text_replace("beat", id, "$");
    else if (input == "#") selected_text_replace("beat", id, "#");
    else if (input == "P") selected_text_replace("beat", id, "P");
    else if (input == "‘") input_text(id, "‘");
    else if (input == "BS") delete_text(id);
    else if (input == "In") selected_html_append("part", id, "Intro");
    else if (input == "partA") selected_html_append("part", id, "A");
    else if (input == "partB") selected_html_append("part", id, "B");
    else if (input == "partC") selected_html_append("part", id, "C");
    else if (input == "Chorus") selected_html_append("part", id, "Chorus");
    else if (input == "End") selected_html_append("part", id, "Ending");
    else if (input == "Solo") selected_html_append("part", id, "Solo");
    else if (input == "break") selected_html_append("indicator", id, "break");
    else if (input == "repeat") selected_html_replace("repeat", id, "repeat");
    else {
      input_text(id, input);
    }
  });

  function selected_html_replace(unit_name, id, input) {
    var selected_element = $(".c-js__cursor")
      .parent()
      .find(".c-chordunit__" + unit_name);
    var insertHTML = change_input_to_HTML(unit_name, input);

    selected_element.html(insertHTML);
    var new_element = $(".c-js__cursor")
      .parent()
      .find(".c-chordunit__" + unit_name);
    $("#chord_chordunits_attributes_" + id + "_" + unit_name).val(
      new_element.text()
    );
  }

  function selected_html_append(unit_name, id, input) {
    var selected_element = $(".c-js__cursor")
      .parent()
      .find(".c-chordunit__" + unit_name);
    var insertHTML = change_input_to_HTML(unit_name, input);

    if (selected_element.html().includes(insertHTML)) {
      // same value has input
      selected_element.children().remove(":contains('" + input + "')");
    } else if (selected_element.html() == "") {
      // no value has input
      selected_element.append(insertHTML);
    } else {
      // different value has input
      selected_element.append(insertHTML);
    }
    var new_element = $(".c-js__cursor")
      .parent()
      .find(".c-chordunit__" + unit_name);

    var value_of_part = "";

    new_element.children().each(function (i, element) {
      if (value_of_part != "") value_of_part += ", ";
      value_of_part += $(element).text();
    });
    $("#chord_chordunits_attributes_" + id + "_" + unit_name).val(
      value_of_part
    );
  }

  function change_input_to_HTML(unit_name, input) {
    var html;
    if (unit_name == "part") {
      html = `<div class="c-chord-edit__js-part">${input}</div>`;
    } else if (unit_name == "indicator") {
      html = `<div class="c-chord-edit__js-indicator">${input}</div>`;
    } else if (unit_name == "repeat") {
      var repeat_number = judge_repeat_number();
      if (repeat_number != "") {
        html = `<div class="c-chord-edit__js-repeat">${judge_repeat_number()}</div>`;
      } else {
        html = ``;
      }
    }
    return html;
  }

  function judge_repeat_number() {
    var selected_element = $(".c-js__cursor")
      .parent()
      .find(".c-chordunit__repeat");

    const repeat_num_array = ["1.", "2.", "3."];
    var i = repeat_num_array.indexOf(selected_element.text());
    i = i + 1;
    if (i + 1 > repeat_num_array.length) {
      // if i-st value is last in repeat_num_array
      return "";
    } else {
      // other
      return repeat_num_array[i];
    }
  }

  // 楽譜記号の処理(共通)
  function selected_text_replace(unit_name, id, input) {
    var selected_element = $(".c-js__cursor")
      .parent()
      .find(".c-chordunit__" + unit_name);
    if (selected_element.text() == input) {
      // 表示値と入力値が一致した場合は、削除
      selected_element.text("");
    } else {
      // 表示値と入力値が一致しない場合は、クリアした後で挿入
      selected_element.text("");
      selected_element.text(input);
    }
    $("#chord_chordunits_attributes_" + id + "_" + unit_name).val(
      selected_element.text()
    );
  }

  // 音名の入力処理
  function input_text(id, letter) {
    var text_value = $("#chord_chordunits_attributes_" + id + "_text").val();

    text_value = text_value + letter;
    $("#chord_chordunits_attributes_" + id + "_text").val(text_value);
    var unit_id = $(".c-js__cursor").attr("id");
    text_display(unit_id, text_value);
  }

  // 音名の削除処理
  function delete_text(id) {
    var text_value = $("#chord_chordunits_attributes_" + id + "_text").val();
    text_value = text_value.slice(0, -1);
    $("#chord_chordunits_attributes_" + id + "_text").val(text_value);
    var unit_id = $(".c-js__cursor").attr("id");
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
        var html = `<span class="c-font__repeat">‘</span>`;
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
    $(".c-chord-edit__text-window").text("");

    unit_id = unit_id.replace("unit_0-", "");

    var get_input = $("#chord_chordunits_attributes_" + unit_id + "_text").attr(
      "value"
    );

    $(".c-chord-edit__text-window").text(get_input);
  }

  $(document).ready(function () {
    $(".c-chordunit__wrapper").each(function (i, chordunit) {
      var letter = $(chordunit).find(".c-chordunit__text").attr("value");
      var unit_id = $(chordunit).find(".c-chordunit").attr("id");

      cursor_display(unit_id);

      if (letter != undefined) {
        letter = letter.trim();
        text_display(unit_id, letter);
      }

      // part_display
      var value_of_part = $(chordunit).find(".c-chordunit__part").text();
      if (value_of_part != "") {
        var part_array = value_of_part.split(", ");
        $(chordunit).find(".c-chordunit__part").empty();
        $.each(part_array, function (j, part) {
          selected_html_append("part", i, part);
        });
      }

      // repeat_display
      var value_of_repeat = $(chordunit).find(".c-chordunit__repeat").text();
      if (value_of_repeat != "") {
        var html = `<div class="c-chord-edit__js-repeat">${value_of_repeat}</div>`;
        $(chordunit).find(".c-chordunit__repeat").html(html);
      }

      // if page shown now is chord#new and no rollback.
      if (
        $(".js-judge__create-chord").length &&
        $(".l-header__notice").text().length == 0
      ) {
        default_input(i);
      }
    });

    $(".c-chordunit").removeClass("c-js__cursor");
  });

  // i番目のchordunitに対してiが特定の値のときに縦線を挿入する
  function default_input(i) {
    if (i % 4 == 0) {
      // call "cursor_display" function, because "selected_text_replace" input in cursor selected chordunit
      // cursor_display("unit_0-" + i);
      selected_text_replace("leftbar", i, "'");
    } else if (i % 4 == 3) {
      // call "cursor_display" function, because "selected_text_replace" input in cursor selected chordunit
      // cursor_display("unit_0-" + i);
      selected_text_replace("rightbar", i, "'");
    }
  }
});
