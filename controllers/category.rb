class CategoryController < ApplicationController

  get '/categories' do
    @categories = Category.all
    @categories = @categories.sort_by { |category| category[:name] }
    return @categories.to_json
  end

  get '/category-sources/:id' do
    @category = Category.find(params[:id].to_i)
    @sources = @category.sources.sort_by { |source| source[:name] }
    return @sources.to_json
  end

  get '/sources' do
    @title = 'Select News Sources';
    erb :sources
  end

end
