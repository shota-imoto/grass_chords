$(function () {
  $(document).on("touchend mouseup", ".chord-btns--command", function () {
    var input = $(this).val();

    // 半音の並びを定義
    const absolute_note_array = [
      "G",
      "G#",
      "A",
      "Bb",
      "B",
      "C",
      "C#",
      "D",
      "Eb",
      "E",
      "F",
      "F#",
      "G",
      "A",
      "Bb",
      "B",
      "C",
      "C#",
      "D",
      "Eb",
      "E",
      "F",
      "F#",
    ];

    // 入力コマンドに変換
    if (input == "繰返し始点") input = "{";
    if (input == "繰返し終点") input = "}";
    if (input == "小節区切り") input = "'";
    if (input == "2/4拍子") input = "@";
    if (input == "4/4拍子") input = "$";
    if (input == "3/4拍子") input = "#";
    if (input == "繰返し") input = "‘";
    if (input == "削除") {
      input = $(".chord-text--form").text();
      console.log(input);
      input = input.slice(0, -1);
      $(".chord-text--form").text("");
    }
    // コマンドをテキストエリアに追加
    $(".chord-text--form").append(input);
  });
});
