$(function () {
  // 検索フォームにキーワードが入力されたときに発火
  $(".c-js__search-text").on("keyup", sendForm);
  // チェックボックスの状態が変化したときに発火
  $(".c-js__search-jam").change(sendForm);
  $(".c-js__search-standard").change(sendForm);
  $(".c-js__search-beginner").change(sendForm);
  $(".c-js__search-vocal").change(sendForm);
  $(".c-js__search-instrumental").change(sendForm);

  // フォームを送信する関数
  function sendForm() {
    // 検索ページがincremental_text。コード登録画面が#search_song_name
    var input = $(".c-js__search-text").val();
    var jam = $(".c-js__value-jam").prop("checked");
    var standard = $(".c-js__value-standard").prop("checked");
    var beginner = $(".c-js__value-beginner").prop("checked");
    var vocal = $(".c-js__value-vocal").prop("checked");
    var instrumental = $(".c-js__value-instrumental").prop("checked");
    $.ajax({
      type: "get",
      url: "/songs/search",
      data: {
        keyword: input,
        jam: jam,
        standard: standard,
        beginner: beginner,
        vocal: vocal,
        instrumental: instrumental,
      },
      dataType: "json",
    }).done(function (results) {
      $(".p-search-result__results").empty();
      $(".c-js__result-counter").empty();

      var insertHTML = "";
      $.each(results, function (i, result) {
        insertHTML += viewResult(result);
      });

      $(".p-search-result__results").append(insertHTML);
      $(".c-js__result-counter").text($(results).size() + " results..");
      icon_color();
    });
  }

  // change the color of song attribute icons
  // this function duplicates with icon.js
  function icon_color() {
    $(".c-js__attribute-state").each(function (i, element) {
      if ($(element).attr("value") == "true") {
        $(element).parent().addClass("u-js__attribute-color");
      }
    });
  }

  // コード作成画面用 曲検索
  function songCandidate(result) {
    var html = `<div class="c-song-candidate__list", data-song_id="${result.id}">${result.title}</div>`;
    return html;
  }

  $(".c-js__song-candidate").on("keyup", function () {
    var input = $(this).val();
    $(".c-song-candidate__lists").empty();
    $(".c-song-candidate__lists").addClass("u-display__hidden");

    if (input == "") {
      return;
    }
    $.ajax({
      type: "get",
      url: "/songs/search",
      data: {
        keyword: input,
      },
      dataType: "json",
    }).done(function (results) {
      var insertHTML = "";

      if (results.length == 0) {
        $(".c-song-candidate__lists").addClass("u-display__hidden");
        return;
      }

      $.each(results, function (i, result) {
        insertHTML += songCandidate(result);
        if (i == 4) return false;
      });
      $(".c-song-candidate__lists").removeClass("u-display__hidden");
      $(".c-song-candidate__lists").append(insertHTML);
    });
  });

  $(document).on("touchend mouseup", ".c-song-candidate__list", function () {
    var song_id = $(this).data("song_id");
    var song_name = $(this).text();
    $("#selected_song_id").val(song_id);
    $("#search_song_name").val(song_name);
    $(".c-song-candidate__lists").empty();
    $(".c-song-candidate__lists").addClass("u-display__hidden");
  });
  function stringForm(i) {
    var html = `<div class="strings__string">
    <input value="${i}" type="hidden" name="[tunings_attributes][${
      i - 1
    }][string_num]" id="_tunings_attributes_${i - 1}_string_num">
    <input placeholder="string${i}" type="text" name="[tunings_attributes][${
      i - 1
    }][note_name]" id="_tunings_attributes_${i - 1}_note_name">
    </div>`;

    return html;
  }

  // 楽曲インクリメンタルサーチ
  $(document).on(
    "touchend mouseup",
    ".search-result__instrument-candidate",
    function () {
      var instrument_id = $(this).data("instrument_id");
      var instrument_string = $(this).data("instrument_string");
      var instrument_name = $(this).text();
      $("#selected_instrument_id").val(instrument_id);
      $("#search_instrument_name").val(instrument_name);

      $(".content__search-result").empty();
      $(".content__strings").empty();

      var insertHTML = "";
      var i = 1;
      for (i = 1; i <= instrument_string; i++) {
        insertHTML += stringForm(i);
      }

      $(".content__strings").append(insertHTML);
    }
  );

  // アクションで生成されたデータをviewに反映する
  function viewResult(result) {
    var html = `<a href="/songs/${result.id}"
    ><div class="p-search-result__result">
      <div class="p-search__song-title">
        <h2>
          ${result.title}
        </h2>
      </div>
      <div class="c-icon__attributes">
        <div class="c-icon__attribute">
          <div class="c-icon__inner--jam c-js__attribute-state" value="${
            result.jam
          }">
            <div class="c-form__icon-blank">
              <svg
                class="u-position__icon-docked--bottle"
                height="22px"
                width="19px"
              >
                <!--?xml version="1.0" encoding="utf-8"?-->
                <!-- Generator: Adobe Illustrator 18.1.1, SVG Export Plug-In . SVG Version: 6.00 Build 0)  -->
  
                <svg
                  version="1.1"
                  id="_x32_"
                  xmlns="http://www.w3.org/2000/svg"
                  xmlns:xlink="http://www.w3.org/1999/xlink"
                  x="0px"
                  y="0px"
                  viewBox="0 0 512 512"
                  style="width: 256px; height: 256px;"
                  xml:space="preserve"
                >
                  <g>
                    <path
                      d="M463.24,197.597c-6.281-11.285-14.002-20.115-21.354-27.411c-11.107-10.906-21.153-18.868-27.121-26.38
        c-3.04-3.748-5.179-7.23-6.683-11.139c-1.488-3.925-2.453-8.397-2.469-14.614h-41.179c-0.008,9.571,1.448,18.458,4.15,26.436
        c4.713,14.051,13.022,24.684,21.153,33.056c6.145,6.33,12.289,11.63,17.807,16.769c8.332,7.714,15.112,14.872,19.962,23.751
        c4.801,8.904,8.252,19.866,8.316,37.255c0,82.359,0,98.822,0,137.259c0.008,9.104-0.346,19.053-1.818,28.504
        c-1.094,7.086-2.815,13.85-5.277,19.753c-3.764,8.912-8.75,15.676-16.568,20.848c-7.85,5.115-19.439,9.096-38.107,9.137H137.947
        c-16.568-0.016-27.619-3.21-35.332-7.464c-5.807-3.234-9.974-7.118-13.448-11.855c-5.179-7.062-8.621-16.416-10.576-26.912
        c-1.971-10.448-2.421-21.764-2.413-32.01c0-38.437,0-54.9,0-137.259c0.064-17.662,3.619-28.697,8.55-37.681
        c3.755-6.732,8.582-12.443,14.412-18.242c8.654-8.734,19.785-17.155,30.048-29.614c5.075-6.233,9.829-13.625,13.167-22.352
        c3.369-8.71,5.227-18.619,5.212-29.38h-41.18c-0.008,5.525-0.788,9.675-1.986,13.278c-2.116,6.217-5.767,11.389-11.727,17.566
        c-4.424,4.592-10.046,9.507-16.239,15.233c-9.232,8.59-19.882,19.214-28.07,34.174c-8.236,14.936-13.431,33.868-13.367,57.016
        c0,82.359,0,98.822,0,137.259c0.008,10.11,0.338,22.126,2.3,34.809c1.48,9.515,3.876,19.448,7.946,29.252
        c6.032,14.646,16.271,29.219,32.035,39.498c15.732,10.327,36.088,15.893,60.667,15.861h236.106
        c21.868,0.016,40.326-4.344,55.262-12.612c11.187-6.16,20.147-14.469,26.798-23.638c10.03-13.802,15.049-29.155,17.767-43.568
        c2.694-14.453,3.112-28.231,3.121-39.603c0-38.437,0-54.9,0-137.259C477.066,231.803,471.693,212.636,463.24,197.597z"
                    ></path>
                    <path
                      class="st0"
                      d="M425.978,74.002C425.978,33.128,398.599,0,364.82,0H147.18C113.4,0,86.022,33.128,86.022,74.002v20.92h339.956
        V74.002z"
                    ></path>
                  </g>
                </svg>
              </svg>
              <svg
                class="u-position__icon-docked--strawberry"
                height="10px"
                width="10px"
              >
                <!--?xml version="1.0" encoding="utf-8"?-->
                <!-- Generator: Adobe Illustrator 18.0.0, SVG Export Plug-In . SVG Version: 6.00 Build 0)  -->
  
                <svg
                  version="1.1"
                  id="_x32_"
                  xmlns="http://www.w3.org/2000/svg"
                  xmlns:xlink="http://www.w3.org/1999/xlink"
                  x="0px"
                  y="0px"
                  viewBox="0 0 512 512"
                  style="width: 256px; height: 256px;"
                  xml:space="preserve"
                >
                  <g>
                    <polygon
                      points="512,230.427 453.046,186.849 472.924,134.5 477.682,122.074 477.643,122.07 477.702,121.914 
        399.752,112.409 391.784,49.226 389.944,34.337 389.907,34.349 389.887,34.185 325.358,59.029 296.776,20.76 281.465,0.113 
        281.429,0.207 281.316,0.055 262.164,51.35 462.294,249.305 494.435,237.098 511.906,230.555 511.824,230.493 	"
                    ></polygon>
                    <path
                      class=""
                      d="M284.185,96.922c-9.375-9.38-28.158-18.734-50.886-23.571c-0.248-0.051-0.488-0.109-0.738-0.164
        c-9.544-1.979-19.696-3.24-30.246-3.24c-29.43,0-73.41,8.893-115.774,51.256c-1.729,1.725-3.254,3.619-4.919,5.399
        c-1.417,1.518-2.816,3.045-4.187,4.598c-3.49,3.947-6.824,8.003-10.025,12.16c-0.841,1.097-1.687,2.194-2.51,3.302
        C6.765,224.985-3.08,336.085,0.718,388.689c3.439,47.548,23.996,74.718,35.946,86.679c11.953,11.946,39.112,32.495,86.667,35.93
        c5.934,0.43,12.636,0.648,19.921,0.648c0,0,0.004,0,0.008,0c8.651,0,28.835-0.449,54.934-3.763c0.95-0.117,1.908-0.246,2.865-0.375
        c1.526-0.199,3.061-0.41,4.622-0.632c1.548-0.222,3.101-0.449,4.667-0.687c1.052-0.16,2.113-0.328,3.18-0.5
        c1.868-0.297,3.74-0.601,5.631-0.929c0.906-0.152,1.825-0.32,2.739-0.484c1.984-0.355,3.969-0.71,5.976-1.093
        c1.054-0.203,2.126-0.426,3.189-0.636c1.844-0.367,3.685-0.73,5.543-1.124c1.716-0.363,3.457-0.758,5.192-1.148
        c1.223-0.273,2.439-0.535,3.666-0.82c48.43-11.278,103.969-32.897,145.344-74.273c79.036-79.028,49.796-172.132,24.289-197.643
        L284.185,96.922z M124.967,404.78c-1.788,6.262-5.91,12.836-11.602,18.527c-7.733,7.73-17.2,12.539-24.703,12.539
        c-3.459,0-6.336-1.054-8.323-3.037c-6.48-6.48-2.218-21.299,9.506-33.033c7.729-7.73,17.196-12.531,24.707-12.531
        c3.459,0,6.336,1.046,8.319,3.029C126.001,393.404,126.743,398.557,124.967,404.78z M139.219,281.265
        c-1.784,6.254-5.906,12.835-11.598,18.523c-7.737,7.733-17.204,12.535-24.707,12.535c-3.459,0-6.336-1.046-8.319-3.037
        c-6.488-6.496-2.225-21.31,9.502-33.026c7.737-7.737,17.204-12.539,24.707-12.539c3.455,0,6.332,1.046,8.315,3.037
        C140.25,269.89,140.999,275.043,139.219,281.265z M177.222,162.49c-1.788,6.258-5.906,12.836-11.594,18.523
        c-7.737,7.733-17.208,12.535-24.71,12.535c-3.459,0-6.336-1.046-8.319-3.037c-1.983-1.979-3.033-4.856-3.033-8.315
        c0-7.503,4.802-16.97,12.539-24.699c7.726-7.734,17.188-12.539,24.695-12.539c3.463,0,6.344,1.05,8.331,3.041
        C178.257,151.122,178.998,156.267,177.222,162.49z M243.734,390.539c-1.788,6.254-5.906,12.836-11.598,18.523
        c-7.734,7.73-17.2,12.531-24.707,12.531c-3.459,0-6.336-1.05-8.323-3.033c-6.484-6.488-2.225-21.307,9.498-33.026
        c7.737-7.737,17.204-12.539,24.707-12.539c3.463,0,6.34,1.05,8.327,3.037C244.769,379.163,245.514,384.316,243.734,390.539z
         M260.638,276.034c-7.737,7.73-17.204,12.531-24.707,12.531c-3.459,0-6.336-1.046-8.319-3.037
        c-6.484-6.48-2.221-21.299,9.502-33.026c7.737-7.737,17.208-12.539,24.707-12.539c3.459,0,6.336,1.046,8.323,3.037
        C276.631,249.493,272.368,264.311,260.638,276.034z M346.153,361.55c-7.734,7.729-17.196,12.535-24.699,12.535
        c-3.462,0-6.34-1.05-8.326-3.037c-6.484-6.484-2.225-21.303,9.494-33.03c7.737-7.733,17.2-12.535,24.695-12.535
        c3.466,0,6.348,1.054,8.334,3.049c1.987,1.979,3.037,4.856,3.041,8.311C358.696,344.35,353.89,353.817,346.153,361.55z"
                    ></path>
                  </g>
                </svg>
              </svg>
            </div>
          </div>
        </div>
        <div class="c-icon__attribute">
          <i class="fas fa-users c-icon__inner--standard c-js__attribute-state" value="${
            result.standard
          }"></i>
        </div>
        <div class="c-icon__attribute">
          <svg
            class="c-icon__inner--beginner c-js__attribute-state" value="${
              result.beginner
            }"
            height="19px"
            width="19px"
          >
            <!--?xml version="1.0" encoding="utf-8"?-->
            <!-- Generator: Adobe Illustrator 19.1.1, SVG Export Plug-In . SVG Version: 6.00 Build 0)  -->
            <svg
              version="1.1"
              id="_x31_0"
              xmlns="http://www.w3.org/2000/svg"
              xmlns:xlink="http://www.w3.org/1999/xlink"
              x="0px"
              y="0px"
              viewBox="0 0 512 512"
              xml:space="preserve"
            >
              <g>
                <path
                  class="st0"
                  d="M388.518,2.742c-21.72-7.042-44.878-0.278-59.428,17.489l-68.943,84.101c-1.145,1.385-2.243,2.815-3.334,4.246
        c-0.282,0.332-0.526,0.653-0.824,0.989c-1.328-1.774-2.698-3.518-4.102-5.223l-68.958-84.12
        C168.336,2.453,145.133-4.3,123.417,2.77c-23.242,7.569-38.063,30.456-38.063,54.895v227.714c0,17.194,6.001,33.981,16.897,47.266
        l142.758,174.148c5.692,6.944,16.314,6.944,22.006,0l142.731-174.145c10.896-13.288,16.901-30.074,16.901-47.269V57.642
        C426.646,33.18,411.79,10.286,388.518,2.742z M385.947,285.378c0,7.81-2.717,15.428-7.677,21.46L261.028,450.573
        c-1.69,2.071-5.043,0.874-5.043-1.797V174.881c0-2.297,0.805-4.521,2.278-6.283L360.565,46.041
        c2.823-3.426,6.662-5.318,10.827-5.318c2.422,0,4.96,0.637,7.275,1.9c4.777,2.602,7.28,8.058,7.28,13.494V285.378z"
                ></path>
              </g>
            </svg>
          </svg>
        </div>
        <div class="c-icon__attribute">
          <i class="fas fa-microphone-alt c-icon__inner--vocal c-js__attribute-state" value="${
            result.vocal
          }"></i>
        </div>
        <div class="c-icon__attribute">
          <i class="fas fa-guitar c-icon__inner--instrumental c-js__attribute-state" value="${
            result.instrumental
          }"></i>
        </div>
      </div>
      <div class="c-review__btn">
        <div class="c-review__icon">
          <i class="fas fa-lightbulb c-review__icon-practice"></i>
        </div>
        <div class="c-review__amount">
          ${result.chords.reduce(
            (sum, chord) => sum + chord.practices_count,
            0
          )}
        </div>
        <div class="c-review__text">
          練習してる？
        </div>
      </div>
    </div>
  </a>
  `;

    return html;
  }
});
