$(function () {
  // $(".navi-menu").on("touchend mouseup", function () {
  //   var v_position = 0;

  //   console.log("hakka");
  //   $("#navi").stop().animate({ top: v_position }, 400);
  // });

  $(".navi-menu").on("touchend, mouseup", function () {
    if ($("#navi").hasClass("open")) {
      // メニューがプルアップする
      $("#navi").removeClass("open");
      $("#navi").addClass("close");

      $(".navi-menu span").eq(0).removeClass("open-top");
      $(".navi-menu span").eq(1).removeClass("open-middle");
      $(".navi-menu span").eq(2).removeClass("open-bottom");

      $(".navi-menu span").eq(0).addClass("close-top");
      $(".navi-menu span").eq(1).addClass("close-middle");
      $(".navi-menu span").eq(2).addClass("close-bottom");
    } else {
      // メニューがプルダウンする
      $("#navi").addClass("open");
      $("#navi").removeClass("close");
      $("#navi").show();

      $(".navi-menu span").eq(0).removeClass("close-top");
      $(".navi-menu span").eq(1).removeClass("close-middle");
      $(".navi-menu span").eq(2).removeClass("close-bottom");

      $(".navi-menu span").eq(0).addClass("open-top");
      $(".navi-menu span").eq(1).addClass("open-middle");
      $(".navi-menu span").eq(2).addClass("open-bottom");
    }
  });
});
