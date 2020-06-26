// // c-js__like
// $(function () {
//   $(".c-js__review").on("touchend, mouseup", function () {
//     chord_id = $(this).parent().attr("value");

//     if ($(this).hasClass("c-js__not-like")) {
//       $.ajax({
//         type: "post",
//         url: "/likes",
//         data: {
//           chord_id: chord_id,
//         },
//         dataType: "json",
//       }).done(function (data) {
//         console.log($(".c-js__review-" + data.id).find(".c-js__review"));
//         $(".c-js__review-" + data.id)
//           .find(".c-js__review")
//           .addClass("c-js__like");
//         $(".c-js__review-" + data.id)
//           .find(".c-js__review")
//           .removeClass("c-js__not-like");
//       });
//     } else if ($(this).hasClass("c-js__like")) {
//       $.ajax({
//         type: "delete",
//         url: "/like/:id",
//         data: {
//           chord_id: chord_id,
//         },
//         dataType: "json",
//       }).done(function (data) {
//         console.log("dan");
//       });
//     }
//   });
// });
