$(function() {
  $('#sheet_management').DataTable({
    pagingType: 'full_numbers',
    lengthChange: false,
    order: [[0, 'desc']]
  });
});