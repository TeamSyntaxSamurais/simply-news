$('document').ready( function() {

  // highlight checked sources
  selectImages();

  // toggle check on checkbox when image is clicked
  checkUncheck();

  $('#news-sources-container').off('click'); // without this, click event will fire twice
  $('#news-sources-container').on('click', '.form-image', function(){
    var checkbox = $(this).next(); // select checkbox that follows the clicked image
    checkbox.trigger('click');
    if( checkbox.is(':checked') ) { // toggle checked-image class
      $(this).addClass('checked-image');
    } else {
      $(this).removeClass('checked-image');
    }
    checkUncheck();
  });

  // close overlay on click
  $('.close-overlay').click( function() {
    $('#overlay-outer').hide();
  });

});

// add checked-image class to selected sources
function selectImages() {
  $('input[type="checkbox"]:checked').prev().addClass('checked-image');
}

function checkUncheck() {
  // uncheck when checked is clicked
  var xCircle = $('<i class="fa fa-times-circle-o"></i>'); // fontawesome x
  var unchecked = $('.form-image').not('.checked-image').next(); // select unchecked checkboxes
  unchecked.next().remove(); // remove checkmark
  xCircle.insertAfter(unchecked); // add x
  // check when unchecked is clicked
  var vCircle = $('<i class="fa fa-check-circle-o"></i>'); // fontawesome checkmark
  var checked = $('.form-image.checked-image').next();
  checked.next().remove();
  vCircle.insertAfter(checked);
}
