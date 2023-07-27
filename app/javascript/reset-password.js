$(function() {
  $("form#resetPasswordForm").validate({
    rules: {
      'current_password': 'required',
      'password': {
          minlength: 8
      },
      'password_confirmation': {
          minlength: 8,
          equalTo: '[name="password"]'
      }
    },
    errorPlacement: function (error, element) {
      error.insertAfter(element);
    }
  });

  $("#resetPasswordSubmit").on("click", function() {
    if($('form#resetPasswordForm').valid()) {
      return true;
    } else {
      return false;
    }
  });
});