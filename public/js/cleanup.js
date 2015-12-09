// Remove images, divs, br and iframe elements
// Move to back end to reduce load time
$('document').ready( function() {
  $('.article-list img').remove();
  $('.article-list div').remove();
  // $('.article-list article p a').remove();
  $('.article-list article p br').remove();
  $('.article-list iframe').remove();
});
