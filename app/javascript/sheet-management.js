$(function() {
  $('#sheet_management').DataTable({
    pagingType: 'full_numbers',
    lengthChange: false,
    order: [[0, 'desc']],
    "aoColumnDefs": [
        { "bSortable": false, "aTargets": [ 4 ] },
        { "bSearchable": false, "aTargets": [ 4 ] }
    ]
  });

  $('#sheet_management .delete-sheet').on('click', function(e) {
    var url = this.href;
    var status = confirm("Are you sure, you want delete this data sheet?");
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
});