class SourceController < ApplicationController

  get '/' do
    @title = 'News Feed'
    @sources = get_sources
    erb :feed
  end

  get '/source/:id' do
    id = params[:id].to_i
    @source = Source.find(id)
    @title = @source[:name]
    erb :single_source
  end

  get '/choose-sources' do
    @sources = get_sources
    @title = 'Choose News Sources'
    erb :choose_sources
  end

  def get_sources
    if session[:current_account].nil?
      sources = Source.all
    else
      sources = session[:current_account].sources
    end
    return sources.sort_by { |source| source[:name] }
  end

  def rss_to_hash url, qty=false
    begin
      page = Nokogiri::XML(open(url))
    rescue Exception => e
      puts "Couldn't read \"#{ url }\": #{ e }"
      return
    end
    hash = Hash.from_xml(page.to_xml)
    type = type_of_rss hash
    if type == 'rss1'
      items = hash["rss"]["channel"]["item"]
      items.each do |item|
        unless item["descripion"].nil?
          item["description"] = item["description"].split('<br')[0]
        end
      end
    elsif type == 'rss2'
      items = hash["feed"]["entry"]
      items.each do |item|
        item['description'] = item['content']
      end
    end
    items.each do |item|
      parse_link item
      parse_description item
    end
    if qty
      return items[0..qty]
    else
      return items
    end
  end

  def type_of_rss hash
    if (hash.has_key?('rss'))
      return 'rss1' # NPR-style RSS
    elsif (hash.has_key?('feed'))
      return 'rss2' # Verge-style RSS
    end
  end

  def parse_link item
    unless item["link"].is_a? String
      if item["link"].is_a? Hash # Verge format
        item["link"] = item["link"]["href"]
      elsif item["link"].is_a? Array # NYT format
        item["link"] = item["link"][0]["href"]
      end
    end
  end

  def parse_description item
    if item["description"].is_a? Array
      item["description"] = item["description"][0]
    end
  end

end
