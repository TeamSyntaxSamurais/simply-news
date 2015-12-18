jQuery(document).ready( function() {
  jQuery.ajax({
    url: '/category/categories',
    type: 'GET',
    dataType: 'json',
    success: function(data) {
      for( var i = 0; i < data.length; i++ ) {
        if(data[i].sources.length != 0) { // if category has sources
          var category = new Category(data[i]); // create and render the Category
          category.initialize();
          category.render();
        }
      }
    },
    error: function(data) {
      console.log('error');
      console.log(data);
    }
  });
});

var Category = function(category) {
  this.id = category.category.id;
  this.name = category.category.name;
  this.sources = category.sources;
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
    this.appendTo = document.getElementById('news-sources-container');
    this.container.appendChild(this.col);
    this.appendTo.appendChild(this.container);
    this.renderSources();
  }
  this.renderSources = function() {
    for( var i = 0; i < this.sources.length; i++ ) {
      var source = new Source(this.sources[i], i, this.container);
      source.initialize();
      source.render();
    }
  }
}

var Source = function(source, i, container) {
  this.count = i;
  this.id = source.id;
  this.name = source.name;
  this.checked = source.checked;
  this.imageUrl = '/images/' + source.image_url;
  this.appendTo = container;
  this.initialize = function() {
    this.container = document.createElement('div');
    this.container.className = 'col-xs-6 col-sm-3 news-source';
    if( this.count % 2 == 0 ) { // odd images on left (starting at 0)
      this.className += ' left-source';
    } else {
      this.container.className += ' right-source';
    }
    this.img = document.createElement('img');
    this.img.alt = this.name;
    this.img.className = 'form-image';
    this.img.src = this.imageUrl;
    this.checkbox = document.createElement('input');
    this.checkbox.type = 'checkbox';
    this.checkbox.name = 'source_' + this.id;
    if(this.checked == true) {
      this.checkbox.checked = 'checked';
    }
  }
  this.render = function() {
    this.container.appendChild(this.img);
    this.container.appendChild(this.checkbox);
    this.appendTo.appendChild(this.container);
    selectImages();
    checkUncheck();
  }
}
