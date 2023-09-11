$(function() {
  $("form#loginForm").validate({
    rules: {
      'user[email]': {
        required: true,
        email: true
      },
      'user[password]': 'required'
    },
    errorPlacement: function (error, element) {
      error.insertAfter(element);
    }
  });

  $("#loginSubmit").on("click", function() {
    if($('form#loginForm').valid()) {
      return true;
    } else {
      return false;
    }
  });
  $(".toggle-password").on("click", function() {
    $(this).toggleClass("ti-lock ti-unlock");
    var input = $($(this).attr("toggle"));
    if (input.attr("type") == "password") {
      input.attr("type", "text");
    } else {
      input.attr("type", "password");
    }
  });
});