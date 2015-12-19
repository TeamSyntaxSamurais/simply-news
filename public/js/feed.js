$(document).ready( function() {
  $.ajax({
    url: '/deliver_feed',
    type: 'GET',
    dataType: 'json',
    success: function(data) {
      for( i = 0; i < data.length; i++ ) {
        var source = new Source(data[i]);
        source.initialize();
        source.render();
      }
    },
    error: function(data) {
      console.log('error');
      console.log(data);
    }
  });
});

var Source = function(source) {
  this.id = source.id;
  this.name = source.name;
  this.rss_url = source.rss_url;
  this.homepage_url = source.homepage_url;
  this.container = document.getElementById('feed-container');
  this.initialize = function() {
    this.sourceContainer = document.createElement('section');
    this.sourceContainer.className = 'row';
    this.sourceName = document.createElement('div');
    this.sourceName.className = 'col-xs-12 source-title';
    this.sourceName.innerHTML = '<h3>' + this.name + '</h3>';
    this.articleContainer = document.createElement('div');
    this.articleContainer.className = 'col-xs-12 article-list';
    this.articleContainer.id = 'source_' + this.id;
    this.moreLink = document.createElement('div');
    this.moreLink.className = 'col-xs-12';
    this.moreLink.innerHTML = '<h4><a href="/source/' + this.id + '">More from ' + this.name + '</a></h4>';
  }
  this.render = function() {
    this.sourceContainer.appendChild(this.sourceName);
    this.sourceContainer.appendChild(this.articleContainer);
    this.container.appendChild(this.sourceContainer);
    this.getArticles();
    this.sourceContainer.appendChild(this.moreLink);
  }
  this.getArticles = function() {
    $.ajax({
      url: '/deliver_articles',
      type: 'GET',
      dataType: 'json',
      container: this.articleContainer,
      data: {
        rss_url: this.rss_url,
        qty: 2
      },
      success: function(data) {
        for( i = 0; i < data.length; i++ ) {
          console.log(data[i]);
          // console.log(this.container);
          var article = new Article(data[i], this.container);
          article.initialize();
          article.render();
        }
      },
      error: function(data) {
        console.log('error');
        console.log('data');
      }
    });
  }
}
var Article = function(article, container) {
  this.title = article.title;
  this.description = article.description;
  this.link = article.link;
  this.container = container;
  this.date = article.display_date;
  this.initialize = function() {
    this.element = document.createElement('article');
    this.heading = document.createElement('h4');
    this.heading.innerHTML = '<a href="' + this.link + '" target="_blank">' + this.title + '</a> ';
    this.byline = document.createElement('small');
    this.byline.innerHTML = ' ' + this.date;
    this.heading.appendChild(this.byline);
    this.element.appendChild(this.heading);
    this.textContent = document.createElement('p');
    this.textContent.innerHTML = this.description;
    this.element.appendChild(this.textContent);
  }
  this.render = function() {
    this.container.appendChild(this.element);
  }
}
