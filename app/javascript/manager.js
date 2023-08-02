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

  $('#users_list .delete-manager').on('click', function(e) {
    var url = this.href;
    var status = confirm("Are you sure, you want delete this manager?");
    if(status){
      e.preventDefault();
      $.ajax({
        type:'delete',
        url: url,
        data: { authenticity_token: $('[name="csrf-token"]')[0].content },
        success: function(result) {
          if (result.message) {
            toastr.success(result.message);
            setTimeout(function() {
              window.location.reload();
            }, 1000);
          }
        },
        failure: function(e) {
          console.log(e);
        }
      });
    } else {
      return false;
    }
  })

})