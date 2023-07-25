$(function() {
  $('#users_list').DataTable({
    pagingType: 'full_numbers',
    lengthChange: false,
    order: [[3, 'desc']],
    "aoColumnDefs": [
        { "bSortable": false, "aTargets": [ 4 ] },
        { "bSearchable": false, "aTargets": [ 4 ] }
    ]
  });

  $("form#userManageForm").validate({
    rules: {
      'first_name': 'required',
      'last_name': 'required',
      'email': {
        required: true,
        email: true
      }
    },
    errorPlacement: function (error, element) {
      error.insertAfter(element);
    }
  });

  $("#userManageSubmit").on("click", function() {
    if($('form#userManageForm').valid()) {
      return true;
    } else {
      return false;
    }
  });

})