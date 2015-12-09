$('document').ready( function() {
  // highlight checked sources
  $('input[type="checkbox"]:checked').prev().addClass('checked-image');
  // check checkbox when image is clicked
  $(".form-image").click( function() {
    var checkbox = $(this).next();
    checkbox.trigger('click');
    if( checkbox.is(':checked') ) {
      $(this).addClass('checked-image');
    } else {
      $(this).removeClass('checked-image');
    }
  });
  // check checkbox when label is clicked
  $('input[type="checkbox"] + label').click( function() {
    $(this).prev().trigger('click');
  });
});
