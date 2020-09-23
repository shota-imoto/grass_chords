$(function () {
  $("#new_user").on("submit", function (e) {
    e.preventDefault();
    grecaptcha.ready(function () {
      grecaptcha
        .execute("6LdDibUZAAAAAB3YKCwEDjWuSwzOM86evQRvjWah", {
          action: "submit",
        })
        .then(function (token) {
          // Add your logic to submit to your backend server here.
          $(".c-js__recaptcha-token").val(token);
          // フォーム送信
          $("#new_user").off("submit");
          $("#new_user").submit();
        });
    });
  });
});
