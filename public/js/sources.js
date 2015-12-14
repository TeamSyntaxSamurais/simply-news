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
    this.container = document.createElement('section');
    this.container.className = 'category';
    this.col = document.createElement('div');
    this.col.className = 'col-xs-12 category-title';
    this.heading = document.createElement('h3');
    this.heading.innerHTML = this.name;
    this.col.appendChild(this.heading);
  }
  this.render = function() {
    this.appendTo = document.getElementById('news-sources');
    this.container.appendChild(this.col);
    this.appendTo.appendChild(this.container);
    this.getSources();
  }
  this.getSources = function() {
    $.ajax({
      url: '/category/category-sources/' + this.id,
      type: 'GET',
      dataType: 'json',
      success: function(data) {
        for( i = 0; i < data.length; i++ ) {
          var source = new Source(data[i], i);
          source.initialize();
          source.render();
        }
      },
      error: function(data) {
        console.log('error');
        console.log('data');
      }
    });
  }
}

var Source = function(source, i) {
  this.count = i;
  this.id = source.id;
  this.name = source.name;
  this.imageUrl = '/images/' + source.image_url;
  this.initialize = function() {
    this.container = document.createElement('div');
    this.container.className = 'col-xs-6 col-sm-3';
    if( i % 2 == 0 ) { // odd images on left (starting at 0)
      this.className += ' left-source';
    } else {
      this.container.className += 'right-source';
    }
  // TO DO: mark selected as checked in json
  }
}
