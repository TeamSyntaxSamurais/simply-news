class CategoryController < ApplicationController

  get '/categories' do
    category_records = Category.all
    category_records = category_records.sort_by { |category| category[:name] }
    @categories = []
    category_records.each do |category|
      all_sources = category.sources
      unless all_sources.nil?
        sources = []
        all_sources.each do |source|
          sources.push(source.attributes.to_options)
        end
        if session[:sources]
          current_sources = []
          session[:sources].each do |id|
            current_sources.push(Source.find(id))
          end
        elsif account
          current_sources = account_record.sources
        end
        if current_sources
          current_sources.each do |current_source|
            if sources.find { |source| source[:name] == current_source[:name] }
              sources.find { |source| source[:name] == current_source[:name] }[:checked] = true
            end
          end
        end
        sources = sources.sort_by { |source| source[:name] }
        @categories.push({category: category.attributes.to_options, sources: sources})
      else
        return false
      end
    end
    return @categories.to_json
  end

  get '/category-sources/:id' do
    @category = Category.find(params[:id].to_i)
    @all_sources = @category.sources
    unless @all_sources.nil?
      @sources = []
      @all_sources.each do |source|
        @sources.push(source.attributes.to_options)
      end

      if account
        @account_sources = account_record.sources
        @account_sources.each do |account_source|
          if @sources.find { |source| source[:name] == account_source[:name] }
            @sources.find { |source| source[:name] == account_source[:name] }[:checked] = true
          end
        end
      end
      @sources = @sources.sort_by { |source| source[:name] }
      return @sources.to_json
    else
      return false
    end
  end

  get '/sources' do
    @title = 'Select News Sources'
    @account = account
    erb :sources
  end

end
