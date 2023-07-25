$(function() {
  var table = $('#imported_data').DataTable({
    pagingType: 'full_numbers',
    lengthChange: false,
    order: [[0, 'asc']],
    scrollX: true,
    retrieve: true,
    ajax: {
      url: '/get_stock_items',
      type: 'GET',
      data: {}
    },
    columns: [
      { "data": "id" },
      { "data": "plant" },
      { "data": "plant2" },
      { "data": "plant3" },
      { "data": "retek_class" },
      { "data": "retek_subclass" },
      { "data": "season" },
      { "data": "ean_number" },
      { "data": "rfid_number" },
      { "data": "variant_size" },
      { "data": "style_code" },
      { "data": "st_loc" },
      { "data": "variant" },
      { "data": "mrp" },
      { "data": "soh_blocked_stock" },
      { "data": "soh_without_blocked_stock" },
      { "data": "soh_quantity" },
      { "data": "soh_value" }
    ],
    "columnDefs": [
      {
          "render": function (data, type, row, meta) {
            return meta.row + meta.settings._iDisplayStart + 1;
          },
          "targets": 0
      },
      {
          "render": function ( data, type, row ) {
            if (data === null) {
              data = "";
            } else {
              data = data;
            }
            return '<span class="rfid_text">' + data + '</span><span class="rfid_field" style="display: none;"><input type="text" name="rfid_number" style="width: 150px;" value="' + data + '" /><input type="hidden" name="stock_item_id" value="' + row.id + '" /></span>'
          },
          "targets": 8
      }
    ],
    "rowCallback": function( row, data, index ) {
      if ( (data.rfid_number === "") || (data.rfid_number == null) ){
        $(row).addClass("table-danger");
      } else {
        $(row).addClass("table-success");
      }
    },
    drawCallback: function(){
      if ($('.edit-import-data').text() == "Hide") {
        $(".rfid_text").hide();
        $(".rfid_field").show();
      } else if($('.edit-import-data').text() == "Edit") {
        $(".rfid_field").hide();
        $(".rfid_text").show();
      }
    }
  });

  $(".edit-import-data").on('click', function() {
    if ($(this).text() == "Edit") {
      $(".rfid_field").show();
      $(".rfid_text").hide();
      $(".save-import-data").show();
      $(".edit-import-data").text("Hide");
    } else {
      $(".rfid_field").hide();
      $(".rfid_text").show();
      $(".save-import-data").hide();
      $(".edit-import-data").text("Edit");
    }
    table.columns.adjust().draw();
  })

  $('.save-import-data').on('click', function (e) {
    e.preventDefault();
    var rfid_values = [];
    var stock_item_ids = [];

    table.$('input[name="rfid_number"]').each(function () {
      rfid_values.push($(this).val());
    });
    table.$('input[name="stock_item_id"]').each(function () {
      stock_item_ids.push($(this).val());
    });

    filtered_values = rfid_values.filter(Boolean);
    var duplicateRfids = filtered_values.filter((item, index) => index !== filtered_values.indexOf(item));

    if (duplicateRfids.length > 0) {
      toastr.error("Having duplicate RFID Numbers. Please check.<br>" + duplicateRfids.toString());
    } else {
      $.ajax({
        type:'post',
        url:'/update_rfid_number',
        data: { authenticity_token: $('[name="csrf-token"]')[0].content, rfid_values: rfid_values, stock_item_ids: stock_item_ids},
        success: function(result) {
          if (result.message) {
            $("#total_stock_count").html(result.data.total);
            $("#with_rfid_count").html(result.data.with_rfid);
            $("#without_rfid_count").html(result.data.without_rfid);
            toastr.success(result.message);
            changeRowColor();
          }
        },
        failure: function(e) {
          console.log(e);
        }
      });
    }
  });

  function changeRowColor() {
    var trs = table.$("tbody tr");
    trs.each(function() {
      var tr = $(this);
      if (tr.find('input[name="rfid_number"]').val() == "") {
        if (tr.hasClass("table-success")) {
          tr.removeClass("table-success");
          tr.addClass("table-danger");
        }
      } else {
        tr.find('span[class="rfid_text"]').html(tr.find('input[name="rfid_number"]').val())
        if (tr.hasClass("table-danger")) {
          tr.removeClass("table-danger");
          tr.addClass("table-success");
        }
      }
    })
  }

  $('#deleteDataSheet').on('click', function() {
    var status = confirm("Are you sure, you want delete imported data sheet?");
    if(status){
      $.ajax({
        type:'delete',
        url:'/delete_data_sheet',
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
  });
})