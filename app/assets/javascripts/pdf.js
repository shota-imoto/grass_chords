window.onload = function () {
  // ページ読み込み時に実行したい処理
  var title = document.getElementsByClassName("p-song__header");
  console.log(title);
  title[0].classList.add("test_backred");
};
