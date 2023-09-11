$(function() {

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

  $("#rfidNumbers").on('paste', function() {
    var element = this;
    setTimeout(function () {
      var text = $(element).val();
      text = text.replace(/\s*$/,"");
      text = text.replace(/\s+/g, ",");
      $("#rfidNumbers").val(text);
    }, 100);
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

  var flash_msgs = JSON.parse($("#flashData").text());

  if (flash_msgs.length > 0) {
    var key = flash_msgs[0][0];
    var value = flash_msgs[0][1];

    if(key == 'error' || key == 'alert') {
      toastr.error(value);
    } else if (key == 'success' || key == 'notice') {
      toastr.success(value);
    }
  }
})