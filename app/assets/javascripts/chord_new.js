$(function () {
  $(document).on("touchend mouseup", ".chord-btns--command", function () {
    var input = $(this).val();

    const half_note_array = ["#", "♭"];

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

    // 入力コマンドに変換
    if (input == "繰返し始点") input = "<";
    if (input == "繰返し終点") input = ">";
    if (input == "小節区切り") input = "|";
    if (input == "半小節") input = "*";
    if (input == "2/4拍子") input = "w";
    if (input == "4/4拍子") input = "f";
    if (input == "3/4拍子") input = "t";
    if (input == "拍子") input = "/";
    if (input == "add") input = "+";
    if (input == "削除") {
      input = $(".chord-text--form").text();
      input = input.slice(0, -1);
      $(".chord-text--form").text("");
    }
    // コマンドをテキストエリアに追加
    $(".chord-text--form").append(input);
  });
});
