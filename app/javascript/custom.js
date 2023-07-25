$(function() {
  $('#sheet_management').DataTable({
    pagingType: 'full_numbers',
    lengthChange: false,
    order: [[0, 'desc']]
  });

  $("form#soldItemForm").validate({
    rules: {
      'rfid_values': 'required'
    },
    errorPlacement: function (error, element) {
      error.insertAfter(element);
    }
  });

  $("#soldItemSubmit").on("click", function() {
    if($('form#soldItemForm').valid()) {
      return true;
    } else {
      return false;
    }
  });

  $("#profileDropdown").on("click", function(){
    $(".profile-list").show();
  });

  $(document).on("mouseup", function(e) { 
    var container = new Array();
    container.push($(".profile-list"));
    $.each(container, function(key, value) {
      if (!$(value).is(e.target) && $(value).has(e.target).length === 0) {
        $(value).hide();
      }
    })
  });
})