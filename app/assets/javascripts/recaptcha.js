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
          var email = $("#user_email").val();
          var password = $("#user_password").val();

          $.ajax({
            type: "post",
            url: "/users/sign_in",
            data: {
              user: {
                email: email,
                password: password,
                token: token,
              },
            },
          });
        });
    });
  });
});
