$(function () {
  //----------------------------------------------------------------------------//
  // コード表示の切替

  // 変換後のコードテキストをhtml形式で追加
  function addChordHTML(letter, next_letter, chord_id, row_index) {
    // 書体の判定用
    const array_font_base = ["'", "{", "}", "@", "$", "#", "B", "b"];
    const array_font_repeat = ["‘"];
    const array_font_number = ["1", "2", "3", "14", "4", "41", "42"];
    const array_font_alphabet = [
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
    ];
    const symbol_not_note = ["'", "{", "}", "@", "$", "#"];
    const symbol_beat = ["@", "$", "#"];

    var html = "";

    if (array_font_base.includes(letter))
      html = `<td class="chord_letter__display ${chord_id}_${row_index} font_base">${letter}</td>`;
    else if (array_font_repeat.includes(letter))
      html = `<td class="chord_letter__display ${chord_id}_${row_index} font_repeat">${letter}</td>`;
    else if (array_font_number.includes(letter))
      html = `<td class="chord_letter__display ${chord_id}_${row_index} font_greek">${letter}</td>`;

    if (symbol_not_note.includes(letter.charAt(0)) && letter.length == 2) {
      letter_array = letter.split("");
      html = `<td class="chord_letter__display ${chord_id}_${row_index} font_base position_adjust">`;

      $.each(letter_array, function (i, letter) {
        if (letter == "'") html += `<span class="font_bar">'</span>`;
        else if (letter == "{") {
          html += `<span class="font_wbar_begin">{</span>`;
        } else if (letter == "}")
          html += `<span class="font_wbar_end">}</span>`;
        else if (symbol_beat.includes(letter))
          html += `<span class="font_beat">${letter}</span>`;
      });
      html += `</td>`;
    }

    if (array_font_alphabet.includes(letter)) {
      // "#"と"B"のフォントかぶりを避けるためelse if ではなくif
      if (next_letter != "m") {
        if (letter.length == 2)
          html = `<td class="chord_letter__display ${chord_id}_${row_index} font_base"><span class="font_alphabet">${letter.charAt(
            0
          )}</span><span class="font-base">${letter.charAt(1)}</span></td>`;
        else
          html = `<td class="chord_letter__display ${chord_id}_${row_index} font_alphabet">${letter}</td>`;
      } else {
        if (letter.length == 2)
          html = `<td class="chord_letter__display ${chord_id}_${row_index} font_base"><span class="font_alphabet">${letter.charAt(
            0
          )}</span><span class="font-base">${letter.charAt(
            1
          )}</span><span class="font_minor">m</span></td>`;
        else
          html = `<td class="chord_letter__display ${chord_id}_${row_index}"><span class ="font_alphabet">${letter}</span><span class="font_minor">m</span></td>`;
      }
    }

    if (letter == "'")
      html = `<td class="chord_letter__display ${chord_id}_${row_index} font_base font_bar">${letter}</td>`;
    else if (letter == "{")
      html = `<td class="chord_letter__display ${chord_id}_${row_index} font_base font_wbar_begin">${letter}</td>`;
    else if (letter == "}")
      html = `<td class="chord_letter__display ${chord_id}_${row_index} font_base font_wbar_end">${letter}</td>`;
    return html;
  }

  // 移動ド表示するための関数
  function chord_display_relative(letter) {
    var delete_flag = 0;
    if (letter == "1") letter = "1";
    if (letter == "2") letter = "2";
    if (letter == "3") letter = "3";
    if (letter == "4") letter = "14";
    if (letter == "5") letter = "4";
    if (letter == "6") letter = "41";
    if (letter == "7") letter = "42";

    var output = new Object();
    output.letter = html;
    output.delete_flag = delete_flag;
    return output;
  }

  function note_relative_to_absolute(key_index, letter) {
    // 度数の場合は、keyの音に対して何列後ろに該当する音があるのか計算。1~7それぞれについて足す値は次の通り。
    // 1->+0, 2->+2, 3->+4, 4->+5, 5->+7, 6->+9, 7->+11
    // 場合分けが可能な限り少なく済むように変換操作を行う

    // 2倍して2を引くグループ
    const relative_note_array1 = ["1", "2", "3"];
    // 2倍して3を引くグループ
    const relative_note_array2 = ["4", "5", "6", "7"];
    if (relative_note_array1.includes(letter)) {
      changed_index = key_index + (letter * 2 - 2);
    } else if (relative_note_array2.includes(letter)) {
      changed_index = key_index + (letter * 2 - 3);
    }

    return changed_index;
  }

  // G~F表示するための関数
  function chord_display_absolute(key, letter, last_letter) {
    // 現在のキー表示を算出
    // 「key of 」という文字列を削除
    key = key.replace(/key of /g, "");
    // keyにm記号を含んでいる場合は削除
    if (/#|b|m/.test(key)) {
      minor_flag = 1;
      key = key.replace("m", "");
    }

    // absolute_note_arrayに含まれないが存在しうる表記を抽出し、統一フォーマットに変換する
    const absolute_note_other_array = [
      "Ab",
      "A#",
      "B#",
      "Cb",
      "D#",
      "E#",
      "Fb",
      "Gb",
    ];
    var key_index = absolute_note_other_array.indexOf(key);
    if (key_index == 0) {
      key = "G#";
    } else if (key_index == 1) {
      key = "Bb";
    } else if (key_index == 2) {
      key = "C";
    } else if (key_index == 3) {
      key = "B";
    } else if (key_index == 4) {
      key = "Eb";
    } else if (key_index == 5) {
      key = "F";
    } else if (key_index == 6) {
      key = "E";
    } else if (key_index == 7) {
      key = "F#";
    }
    // 半音の並びを定義
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
    ];

    // keyがabsolute_note_arrayの何番目に位置するか検索
    key_index = absolute_note_array.indexOf(key);

    // keyに対して何度の音なのか、配列中の順番を表す値
    var changed_index;
    var output_letter;

    // 相対音のグループ(絶対音配列に変換する)
    const relative_note_array = ["1", "2", "3", "4", "5", "6", "7"];

    // そのまま表記するグループ
    const symbol_should_not_changed = ["m", "‘"];

    // 区切り記号や拍子などのグループ(ひとまとめにする)
    const symbol_not_note = ["'", "{", "}", "@", "$", "#"];
    // 上記のグループの中で区切り記号を表すグループ
    const symbol_beat = ["@", "$", "#"];
    // 上記のグループの中で拍子を表すグループ
    const symbol_border = ["'", "{", "}"];

    // #またはbに対して用いる変数 フォントの配列より#はBで表す。
    const half_note_array = ["B", "b", "m"];
    var previous_index;

    // $.each(chord_array, function (index, value) {
    var delete_flag = 0;
    changed_index = 0;

    if (symbol_should_not_changed.includes(letter)) {
      output_letter = letter;
    } else if (symbol_not_note.includes(letter)) {
      if (symbol_not_note.includes(last_letter)) {
        delete_flag = 1;
        if (symbol_beat.includes(letter) && symbol_beat.includes(last_letter)) {
          output_letter = letter;
        } else if (
          symbol_border.includes(letter) &&
          symbol_border.includes(last_letter)
        ) {
          output_letter = letter;
        } else {
          output_letter = last_letter + letter;
        }
      } else output_letter = letter;
    } else if (relative_note_array.includes(letter)) {
      changed_index = note_relative_to_absolute(key_index, letter);
      output_letter = absolute_note_array[changed_index];
    } else if (half_note_array.includes(letter)) {
      previous_index = absolute_note_array.indexOf(
        absolute_note_array[last_letter]
      );

      if (letter == "B") {
        delete_flag = 1;

        previous_index = note_relative_to_absolute(key, letter);
        previous_index = previous_index + 1;
        output_letter = absolute_note_array[previous_index];
      }
      if (letter == "b") {
        delete_flag = 1;
        previous_index = note_relative_to_absolute(key, letter);
        previous_index = previous_index - 1;
        output_letter = absolute_note_array[previous_index];
      }
      if (previous_index == -1) {
        previous_index = absolute_note_array.length - 1;
        output_letter = absolute_note_array[previous_index];
      }
      if (letter == "m")
        output_letter = absolute_note_array[previous_index] + "m";
    } else {
      output_letter = "";
    }

    var output = new Object();
    output.letter = output_letter;
    output.delete_flag = delete_flag;
    return output;
  }

  // コード表示の切替 メイン関数
  function chord_display(key) {
    $(".chord_letter__display").remove();

    const symbol_border = ["'", "{", "}"];

    $(".chord_text").each(function (i, record) {
      // 区切り記号のカウント→３カウントごとに新しい行に移行
      // var border_counter = 0;

      chord_id = $(record).attr("id");

      var row_index = 0;
      var tableHTML = `<table class="table_${chord_id}"><tbody><tr>`;

      var row_width = 0;

      $(record)
        .children()
        .each(function (j, data) {
          if (j > 0) {
            // table終点タグを削除
            var delete_index = tableHTML.lastIndexOf("</tr></tbody></table>");
            tableHTML = tableHTML.substring(0, delete_index);

            // 最後尾のtdの幅を取得
            row_width += $("." + chord_id + "_" + row_index)
              .last()
              .width();
          }

          // 文字の取得
          letter = $(data).text().trim();

          // 前の文字を取得
          var last_letter;
          if (j == 0) {
            last_letter = "";
          } else if (j > 0) {
            last_letter = $(".chord_text__chord_letter")[j - 1];
            last_letter = $(last_letter).text().trim();
          }

          // 次の文字を取得
          var next_letter;
          var chord_length = $("#" + chord_id).children().length;
          if (j == chord_length) next_letter = "";
          else if (j < chord_length) {
            next_letter = $(".chord_text__chord_letter")[j + 1];
            next_letter = $(next_letter).text().trim();
          }

          var output;
          // 移動ドがstyle属性を持っているか判定
          if (
            $(".key__key-display--relative-key").attr("style") ==
            "display: flex;"
          ) {
            output = chord_display_relative(letter);
          } else if (
            $(".key__key-display--relative-key").attr("style") ==
            "display: none;"
          ) {
            output = chord_display_absolute(key, letter, last_letter);
          } else {
            output = chord_display_absolute(key, letter, last_letter);
          }

          // delete_flag == 1、つまり#or♭処理をした場合は、前列の文字が不要となるので削除する
          if (output.delete_flag == 1) {
            var delete_index = tableHTML.lastIndexOf("<td ");
            tableHTML = tableHTML.substring(0, delete_index);
          }

          tableHTML += addChordHTML(
            output.letter,
            next_letter,
            chord_id,
            row_index
          );

          if (row_width > $(window).width() - 400) {
            row_index += 1;

            tableHTML += `</tr><tr>`;
            row_width = 0;
            if (symbol_border.includes(letter)) {
              tableHTML += `<td class="font_base">'</td>`;
            }
          }
          tableHTML += `</tr></tbody></table>`;

          // 改行はサイズに基づいて行うため、毎回、削除→appendする
          $(".table_" + chord_id).remove();
          $(".content__chord").append(tableHTML);
        });
    });
  }

  //----------------------------------------------------------------------------//
  // キー表示の切り替え

  // G~Fの絶対キーを設定する場合
  function absolute_key(note_selected, key_now_state) {
    const symbols = ["#", "b"];
    if (symbols.includes(note_selected)) {
      // #またはbに関する処理
      // 現在の表示値に#、b、mが含まれている
      if (/#|b|m/.test(key_now_state)) {
        // 最初の８文字を切り出し＝key of Xまでを代入
        key_now_state = key_now_state.slice(0, 8);
      }
      $(".key__key-display--now").text(key_now_state + note_selected);
    } else if (note_selected == "m") {
      // mに関する処理
      if (/m/.test(key_now_state)) {
        // 最後の1文字を削除（mが存在するとすれば最後尾であるため
        // key_now_state = key_now_state.slice(0, -1);
      } else {
        $(".key__key-display--now").text(key_now_state + note_selected);
      }
    } else {
      // G~Fに関する処理
      $(".key__key-display--now").text("key of " + note_selected);
    }
  }

  //キー選択パレットを開く
  $(".key__key-display").on("touchend mouseup", function () {
    $(".chord-menu__key--palettes").show();
  });

  // キーの切替 キー選択パレット中の文字がクリックされたら起動
  $(".palettes__palette").on("touchend mouseup", function () {
    // クリックした記号を取得
    var note_selected = $.trim($(this).text());
    // 現在の表示値を取得
    var key_now_state = $(".key__key-display--now").text();
    key_now_state = $.trim(key_now_state);
    // 閉じる | 移動ド | 他のキーで場合分け
    if (note_selected == "閉じる") {
      $(".chord-menu__key--palettes").removeAttr("style");
    } else {
      if (note_selected == "移動ド") {
        $(".key__key-display--relative-key").css("display", "flex");
        key_for_registration("relative-key");
      } else {
        $(".key__key-display--relative-key").hide();
        absolute_key(note_selected, key_now_state);
        key_now_state = $(".key__key-display--now").text();

        key_for_registration(key_now_state);
      }
      chord_display(key_now_state);
    }
  });
  // ページ読み込み時の挙動
  $(document).ready(function () {
    var key_now_state = $(".key__key-display--now").text();
    key_now_state = $.trim(key_now_state);
    // absolute_key(note_selected, key_now_state);
    chord_display(key_now_state);
    key_for_registration(key_now_state);
  });

  // コード作成画面用
  function key_for_registration(key_now_state) {
    if ($("#key_name").get(0) != undefined) {
      $("#key_name").val(key_now_state);
    }
  }
});
