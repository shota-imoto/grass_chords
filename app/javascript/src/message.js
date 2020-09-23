// show newest message on message display
$(function () {
  $(document).ready(function () {
    var message_height = $(".p-message__content").height();
    $(".p-message__content").scrollTop(message_height);
  });
});
