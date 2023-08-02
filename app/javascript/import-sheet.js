$(function() {
  $("form#importDataSheetForm").validate({
    rules: {
      'data_sheet[file]': {
        checkFile: true
      }
    },
    errorPlacement: function (error, element) {
      error.insertAfter('.input-group')
    }
  });
  $.validator.addMethod('checkFile', (function(value, element) {
    var file = $("#data_sheet_file")[0].files[0];
    if (file) {
      var fileType = file["type"];
      var fileName = file["name"];
      $("#data_sheet_sheet_name").val(fileName);
      var validFileTypes = ["application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"];
      if ($.inArray(fileType, validFileTypes) !== -1) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }), 'Please upload only files of type (.xlsx).');

  $("#dataSheetSubmit").on("click", function() {
    if($('form#importDataSheetForm').valid()) {
      return true;
    } else {
      return false;
    }
  });

  $("#dataSheetCancel").on("click", function() {
    $("#data_sheet_file").val('');
    $('#importDataSheetForm .file-upload-info').val('');
  });

  $("#data_sheet_file").on("change", function(e) {
    var files = e.target.files;
  })

});