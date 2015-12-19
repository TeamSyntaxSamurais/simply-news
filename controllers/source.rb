class SourceController < ApplicationController

  require 'cgi'
  require 'time'

  get '/' do
    redirect '/category/sources'
  end

  get '/feed' do
    @title = 'News Feed'
    @account = account
    erb :feed
  end

  get '/deliver_feed' do
    return get_sources.to_json
  end

  get '/deliver_articles' do
    url = Nokogiri::HTML.parse( params[:rss_url] )
    articles = rss_to_hash url, params[:qty].to_i
    return articles.to_json
  end

  get '/source/:id' do
    id = params[:id].to_i
    @source = Source.find(id)
    @account = account
    @title = @source[:name]
    erb :single_source
  end

  get '/choose-sources' do
    @all_sources = Source.all
    @sources = []
    @all_sources.each do |source|
      @sources.push(source.attributes.to_options)
    end
    @account_sources = account_record.sources
    @account_sources.each do |account_source|
      @sources.find { |source| source[:name] == account_source[:name] }[:checked] = true
    end
    @sources = @sources.sort_by { |source| source[:name] }
    @title = 'Choose News Sources'
    @account = account
    erb :choose_sources
  end

  post '/save-sources' do
    if account
      account_id = session[:current_account][:id]
    end
    selected = []
    params.each do |id,on|
      source_id = id.split('_')[1].to_i
      if on == "on"
        if account
          account_source = AccountSource.new
          account_source.account_id = account_id
          account_source.source_id = source_id
          account_source.save
        end
        selected.push(source_id)
      end
    end
    session[:sources] = selected
    if account
      AccountSource.where({account_id: account_id}).each do |entry|
        if !selected.include? entry[:source_id]
          entry.delete
        end
      end
    end
    session[:alert] = 'News sources updated.'
    redirect '/feed'
  end

  def get_sources
    ## get sources selected in session
    if session[:sources]
      sources = []
      session[:sources].each do |id|
        sources.push(Source.find(id))
      end
    elsif session[:current_account].nil? || account_record.sources.nil?
      ## Get all sources if no accout and none are selected in this session
      sources = Source.all
    else
      sources = account_record.sources
      session[:sources] = []
      ## store source ids in session if they're not for some reason
      sources.each do |source|
        session[:sources].push(source[:id])
      end
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
    elsif type == 'rss2'
      items = hash["feed"]["entry"]
      items.each do |item|
        item['description'] = item['content']
      end
    end
    items.each do |item|
      parse_link item ## normalize link format
      parse_date item ## normalize date format
      parse_description item ## normalize description format
      clean_description item ## remove unwanted elements
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

  def parse_date item
    date = item["pubDate"] || item ["date"] || item["published"]
    if date
      item["display_date"] = (Time.parse(date) + Time.zone_offset('EST')).strftime("%A, %l:%M%P%Z")
    end
  end

  def parse_description item
    if item["description"].is_a? Array
      item["description"] = item["description"][0]
    end
  end

  def clean_description item
    desc = item["description"]
    if desc.is_a? String
      split_ps = desc.split(/(<\/p>)/) ## split paragraphs
      if split_ps.count > 1
        desc = split_ps[0] + '</p>' ## Keep the first paragraph
      end
      desc.gsub!(/<div.*?\/div>/,'') ## remove divs
      desc.gsub!(/<a.*?\/a>/, '') ## remove links
      desc.gsub!(/<iframe.*?\/iframe>/, '') ## remove iframes
      desc.gsub!(/<img.*?>/,'') ## remove images
      desc.gsub!(/<br\/>/, '') ## remove line breaks
      desc.gsub!(/<br>/, '')
      item["description"] = desc
    end
  end

end
