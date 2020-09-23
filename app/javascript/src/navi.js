$(function () {
  // open global search window
  $(".l-header__search-btn").on("touchend, mouseup", function () {
    if ($(".c-js__menu__fade-in").css("display") == "block") {
      $(".c-js__navi__fade-in").fadeOut();
      $(".c-js__menu__fade-in").fadeOut();
      $(".c-js__menu__fade-in").animate(
        {
          marginBottom: "-=10px",
        },
        {
          duration: 500,
          queue: false,
        }
      );
      $(".l-header__opn-box").removeClass("c-js__menu-opn");
      $(".l-header__opn-box").addClass("c-js__menu-cls");
    }
    $(".c-js__search__fade-in").fadeToggle(100);
  });

  // transform hamburger icon
  $(".l-header__opn-box").on("touchend, mouseup", function () {
    $(this).toggleClass("c-js__menu-opn");
    $(this).toggleClass("c-js__menu-cls");
  });

  // open accordion menu
  $(".l-header__opn-box").on("touchend, mouseup", function () {
    if ($(".c-js__search__fade-in").css("display") == "block") {
      $(".c-js__search__fade-in").fadeOut(100);
    }

    if ($(".c-js__navi__fade-in").css("display") == "none") {
      $(".c-js__navi__fade-in").fadeToggle("fast");
      $(".c-js__menu__fade-in").eq(0).fadeToggle(1000).animate(
        {
          marginBottom: "+=10px",
        },
        {
          duration: 500,
          queue: false,
        }
      );
      $(".c-js__menu__fade-in").eq(1).fadeToggle(1200).animate(
        {
          marginBottom: "+=10px",
        },
        {
          duration: 500,
          queue: false,
        }
      );
      $(".c-js__menu__fade-in").eq(2).fadeToggle(1400).animate(
        {
          marginBottom: "+=10px",
        },
        {
          duration: 500,
          queue: false,
        }
      );
      $(".c-js__menu__fade-in").eq(3).fadeToggle(1600).animate(
        {
          marginBottom: "+=10px",
        },
        {
          duration: 500,
          queue: false,
        }
      );
      $(".c-js__menu__fade-in").eq(4).fadeToggle(1800).animate(
        {
          marginBottom: "+=10px",
        },
        {
          duration: 500,
          queue: false,
        }
      );
    } else {
      $(".c-js__navi__fade-in").fadeToggle();
      $(".c-js__menu__fade-in").fadeToggle();
      $(".c-js__menu__fade-in").animate(
        {
          marginBottom: "-=10px",
        },
        {
          duration: 500,
          queue: false,
        }
      );
    }
  });

  // opne accordion menu
  $(".p-navi__btn-pulldown").on("touched, mouseup", function () {
    $(this).next().slideToggle();
    $(this).find(".p-navi__icon-box").eq(1).toggleClass("c-js__upside-down");
  });
});
