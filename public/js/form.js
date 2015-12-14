$('document').ready( function() {
  // highlight checked sources
  $('input[type="checkbox"]:checked').prev().addClass('checked-image');
  // toggle check on checkbox when image is clicked
  function checkUncheck() {
    var xCircle = $('<i class="fa fa-times-circle-o"></i>');
    var unchecked = $('.form-image').not('.checked-image').next();
    unchecked.next().remove();
    xCircle.insertAfter(unchecked);
    var vCircle = $('<i class="fa fa-check-circle-o"></i>');
    var checked = $('.form-image.checked-image').next();
    checked.next().remove();
    vCircle.insertAfter(checked);
  }
  checkUncheck();
  $(".form-image").click( function() {
    var checkbox = $(this).next();
    checkbox.trigger('click');
    if( checkbox.is(':checked') ) {
      $(this).addClass('checked-image');
    } else {
      $(this).removeClass('checked-image');
    }
    checkUncheck();
  });
  $('.close-overlay').click( function() {
    $('#overlay-outer').hide();
  });
});
