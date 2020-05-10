$(function () {
  //----------------------------------------------------------------------------//
  // コード表示の切替

  // 移動ド表示するための関数
  function chord_display_relative(chord_array, output_array) {
    $.each(chord_array, function (index, value) {
      output_array.push(value);
    });
    var output_array = output_array.join("");

    while (/delete/.test(output_array)) {
      output_array = output_array.replace("delete", "");
    }

    return output_array;
  }

  // G~F表示するための関数
  function chord_display_absolute(key, chord_array, output_array) {
    var minor_flag = 0;

    // 現在のキー表示を算出
    // 「key of 」という文字列を削除
    key = key.replace(/key of /g, "");
    // keyにm記号を含んでいる場合は削除
    if (/#|♭|m/.test(key)) {
      minor_flag = 1;
      key = key.replace("m", "");
    }

    // absolute_note_arrayに含まれないが存在しうる表記を抽出し、統一フォーマットに変換する
    const absolute_note_other_array = [
      "A♭",
      "A#",
      "B#",
      "C♭",
      "D#",
      "E#",
      "F♭",
      "G♭",
    ];
    var key_index = absolute_note_other_array.indexOf(key);
    if (key_index == 0) {
      key = "G#";
    } else if (key_index == 1) {
      key = "B♭";
    } else if (key_index == 2) {
      key = "C";
    } else if (key_index == 3) {
      key = "B";
    } else if (key_index == 4) {
      key = "E♭";
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
      "G#",
      "A",
      "B♭",
      "B",
      "C",
      "C#",
      "D",
      "E♭",
      "E",
      "F",
      "F#",
      "G",
      "A",
      "B♭",
      "B",
      "C",
      "C#",
      "D",
      "E♭",
      "E",
      "F",
      "F#",
    ];

    // keyがabsolute_note_arrayの何番目に位置するか検索
    key_index = absolute_note_array.indexOf(key);

    // 度数の場合は、keyの音に対して何列後ろに該当する音があるのか計算。1~7それぞれについて足す値は次の通り。
    // 1->+0, 2->+2, 3->+4, 4->+5, 5->+7, 6->+9, 7->+10
    // 場合分けが可能な限り少なく済むように変換操作を行う

    // 2倍して2を引くグループ
    const relative_note_array1 = ["1", "2", "3"];
    // 2倍して3を引くグループ
    const relative_note_array2 = ["4", "5", "6"];
    // 3を足すグループ
    const relative_note_array3 = ["7"];

    // 度数に対して用いる変数
    var changed_index;

    // そのまま表記するグループ
    const symbol_should_not_changed = ["|", "m"];

    // #または♭に対して用いる変数
    const half_note_array = ["#", "♭"];
    var previous_index;
    var previous_note;

    $.each(chord_array, function (index, value) {
      changed_index = 0;
      if (symbol_should_not_changed.includes(value)) {
        output_array.push(value);
      } else if (relative_note_array1.includes(value)) {
        changed_index = key_index + (value * 2 - 2);
        output_array.push(absolute_note_array[changed_index]);
      } else if (relative_note_array2.includes(value)) {
        changed_index = key_index + (value * 2 - 3);
        output_array.push(absolute_note_array[changed_index]);
      } else if (relative_note_array3.includes(value)) {
        changed_index = key_index + (value * 1 + 3);
        output_array.push(absolute_note_array[changed_index]);
      } else if (half_note_array.includes(value)) {
        previous_note = output_array[output_array.length - 1];
        previous_index = absolute_note_array.indexOf(previous_note);
        if (value == "#") previous_index = previous_index + 1;

        if (value == "♭") previous_index = previous_index - 1;
        if (previous_index == -1)
          previous_index = absolute_note_array.length - 1;
        output_array[output_array.length - 1] = "delete";
        output_array.push(absolute_note_array[previous_index]);
      }
    });
    var output_array = output_array.join("");

    while (/delete/.test(output_array)) {
      output_array = output_array.replace("delete", "");
    }
    return output_array;
  }

  // コード表示の切替 メイン関数
  function chord_display(key) {
    var chord_text = $(".chord-display--text").text();

    var chord_array = chord_text.split("");
    chord_array.shift();
    chord_array.pop();

    var output_array = [];
    var output_text;
    // 移動ドがstyle属性を持っているか判定
    if (
      $(".key__key-display--relative-key").attr("style") == "display: flex;"
    ) {
      console.log("移動ドが有効");
      output_text = chord_display_relative(chord_array, output_array);
    } else if (
      $(".key__key-display--relative-key").attr("style") == "display: none;"
    ) {
      console.log("絶対表示が有効");
      output_text = chord_display_absolute(key, chord_array, output_array);
    } else {
      output_text = chord_display_absolute(key, chord_array, output_array);
    }
    $(".chord-display--chord-score").text(output_text);
  }

  //----------------------------------------------------------------------------//
  // キー表示の切り替え

  // G~Fの絶対キーを設定する場合
  function absolute_key(note_selected, key_now_state) {
    const symbols = ["#", "♭"];
    if (symbols.includes(note_selected)) {
      // #または♭に関する処理
      // 現在の表示値に#、♭、mが含まれている
      if (/#|♭|m/.test(key_now_state)) {
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
      } else {
        $(".key__key-display--relative-key").hide();
        absolute_key(note_selected, key_now_state);
      }
      key_now_state = $(".key__key-display--now").text();
      chord_display(key_now_state);
    }
  });
  // ページ読み込み時の挙動
  $(document).ready(function () {
    var key_now_state = $(".key__key-display--now").text();
    key_now_state = $.trim(key_now_state);

    // absolute_key(note_selected, key_now_state);
    chord_display(key_now_state);
  });
});
