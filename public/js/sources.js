$(document).ready( function() {
  $.ajax({
    url: '/category/categories',
    type: 'GET',
    dataType: 'json',
    success: function(data) {
      for( i = 0; i < data.length; i++ ) {
        var category = new Category(data[i]);
        category.initialize();
        category.render();
      }
    },
    error: function(data) {
      console.log('error');
      console.log('data');
    }
  });
});

var Category = function(category) {
  this.id = category.id;
  this.name = category.name;
  this.initialize = function() {
    this.element = document.createElement('section');
    this.element.className = 'category';
    this.heading = document.createElement('h3');
    this.heading.innerHTML = this.name;
  }
  this.render = function() {
    this.container = document.getElementById('news-sources');
    this.element.appendChild(this.heading);
    this.container.appendChild(this.element);
  }
}
