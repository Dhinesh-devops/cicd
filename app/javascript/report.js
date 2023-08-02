class reportDataTable {

  applyFilters(category, start_date, end_date, reportTable) {
    $.ajax({
      type:'get',
      url:'/get_stock',
      data: { authenticity_token: $('[name="csrf-token"]')[0].content, category: category,
      start_date: start_date,
      end_date: end_date },
      success: function(result) {
        if (result) {
          reportTable.clear().draw();
          reportTable.rows.add(result.data);
          reportTable.columns.adjust().draw();
        }
      },
      failure: function(e) {
        console.log(e);
      }
    });
  }

  exportReport() {
    var category = $("#reportCategory").val();
    var start_date = $("#reportStartDate").val();
    var end_date = $("#reportEndDate").val();
    toastr.success("Report downloaded successfully");
    window.location = "/download_report?category=" + category + "&start_date=" + start_date + "&end_date=" + end_date;
  }
}

$(function() {
  var category = "";
  var start_date = "";
  var end_date = "";
  var report_data = new reportDataTable();

  var report_table = loadDatatable(category, start_date, end_date);

  function loadDatatable(category, start_date, end_date) {
    var table = $('#report_data').DataTable({
      pagingType: 'full_numbers',
      lengthChange: false,
      scrollX: true,
      retrieve: true,
      ajax: {
        url: '/get_stock',
        type: 'GET',
        data: {
          category: category,
          start_date: start_date,
          end_date: end_date
        }
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
        { "data": "soh_value" },
        { "data": "status"}
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
              if(data == null) {
                return "Missed";
              } else if (data == "scanned") {
                return "Stock";
              } else {
                return "Sold";
              }
            },
            "targets": 18
        }
      ]
    });
    return table;
  }

  $('.input-daterange').datepicker({
    format: "dd/mm/yyyy"
  });

  $('#applyFilters').on('click', function() {
    category = $("#reportCategory").val();
    start_date = $("#reportStartDate").val();
    end_date = $("#reportEndDate").val();

    if ((category == "") && (start_date == "") && (end_date == "")) {
      toastr.error("Please select any filter.");
    } else {
      var reportTable = report_table;
      report_data.applyFilters(category, start_date, end_date, reportTable)
    }
  })

  $('#exportData').on('click', function() {
    report_data.exportReport();
  });
})