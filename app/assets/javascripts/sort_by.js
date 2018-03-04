$(function() {
  $('#sort_by').on('change', function() {
    $(this).closest('form').eq(0).submit()
  });
});
