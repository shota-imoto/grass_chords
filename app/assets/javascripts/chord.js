$(function () {
  //----------------------------------------------------------------------------//
  // コード表示の切替

  // 変換後のコードテキストをhtml形式で追加
  function addChordHTML(letter) {
    // 書体の判定用
    const array_font_base = ["'", "{", "}", "@", "$", "t", "B", "b"];
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
    const array_font_minor = ["m"];
    var add_class = "none-font";

    if (array_font_base.includes(letter)) add_class = "font_base";
    else if (array_font_repeat.includes(letter)) add_class = "font_repeat";
    else if (array_font_number.includes(letter)) add_class = "font_greek";
    else if (array_font_minor.includes(letter)) add_class = "font_minor";

    // "#"と"B"のフォントかぶりを避けるためelse if ではなくif
    if (array_font_alphabet.includes(letter)) {
      if (letter.length == 2) {
        var first_letter = letter.charAt(0);
        var second_letter = letter.charAt(1);

        add_class = `font-alphabet">${first_letter}<a class="chord_letter__display font_base`;
        letter = second_letter;
      } else {
        add_class = "font_alphabet";
      }
    }
    if (letter == "'") add_class = add_class + " font_bar";
    if (letter == "{") add_class = add_class + " font_wbar_begin";
    if (letter == "}") add_class = add_class + " font_wbar_end";

    var html = `<a class="chord_letter__display ${add_class}">${letter}</a>`;
    return html;
  }

  function chordNewLine() {
    const array_border = ["{", "}", "'"];
    var counter = 0;

    $(".chord_letter__display").each(function (index, element) {
      if (array_border.includes($(element).text())) counter += 1;
      console.log(counter);

      if (counter == 3) {
        counter = 0;
        // $(element).append("<br></a><a display='inline-block'>'</a>");
      }
    });
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
    output.letter = letter;
    output.delete_flag = delete_flag;
    return output;
  }

  // G~F表示するための関数
  function chord_display_absolute(key, letter, last_letter) {
    var minor_flag = 0;

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

    // 度数の場合は、keyの音に対して何列後ろに該当する音があるのか計算。1~7それぞれについて足す値は次の通り。
    // 1->+0, 2->+2, 3->+4, 4->+5, 5->+7, 6->+9, 7->+11
    // 場合分けが可能な限り少なく済むように変換操作を行う

    // 2倍して2を引くグループ
    const relative_note_array1 = ["1", "2", "3"];
    // 2倍して3を引くグループ
    const relative_note_array2 = ["4", "5", "6", "7"];

    // keyに対して何度の音なのか、配列中の順番を表す値
    var changed_index;

    // そのまま表記するグループ
    const symbol_should_not_changed = ["'", "m", "{", "}", "@", "$", "t", "‘"];

    // #またはbに対して用いる変数 フォントの配列より#はBで表す。
    const half_note_array = ["B", "b"];
    var previous_index;

    // $.each(chord_array, function (index, value) {
    var delete_flag = 0;
    changed_index = 0;

    if (symbol_should_not_changed.includes(letter)) {
    } else if (relative_note_array1.includes(letter)) {
      changed_index = key_index + (letter * 2 - 2);
      letter = absolute_note_array[changed_index];
    } else if (relative_note_array2.includes(letter)) {
      changed_index = key_index + (letter * 2 - 3);
      letter = absolute_note_array[changed_index];
    } else if (half_note_array.includes(letter)) {
      previous_index = absolute_note_array.indexOf(last_letter);
      delete_flag = 1;

      if (letter == "B") previous_index = previous_index + 1;

      if (letter == "b") previous_index = previous_index - 1;
      if (previous_index == -1) {
        previous_index = absolute_note_array.length - 1;
        letter = absolute_note_array[previous_index];
      }
    } else {
      letter = "";
    }

    var output = new Object();
    output.letter = letter;
    output.delete_flag = delete_flag;
    return output;
  }

  // コード表示の切替 メイン関数
  function chord_display(key) {
    $(".chord_letter__display").remove();
    $(".chord_text__chord_letter").each(function (i, element) {
      var letter = $(element).text();

      var last_letter;
      if (i == 0) {
        last_letter = "";
      } else if (i > 0) {
        last_letter = $(".chord_text__chord_letter")[i - 1];
        last_letter = last_letter.textContent;
      }

      var letter = element;
      letter = letter.textContent;
      letter = letter.trim();

      var output;
      // 移動ドがstyle属性を持っているか判定
      if (
        $(".key__key-display--relative-key").attr("style") == "display: flex;"
      ) {
        output = chord_display_relative(letter);
      } else if (
        $(".key__key-display--relative-key").attr("style") == "display: none;"
      ) {
        output = chord_display_absolute(key, letter, last_letter);
      } else {
        output = chord_display_absolute(key, letter, last_letter);
      }
      // $(".chord_letter__display")[i].textContent = output.letter;

      var insertHTML = addChordHTML(output.letter);
      var chord_id = $(element).parent().attr("id");
      $("#" + chord_id).before(insertHTML);
    });
    chordNewLine();
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
