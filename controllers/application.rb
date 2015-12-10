class ApplicationController < Sinatra::Base

  require 'bundler'
  Bundler.require

  ActiveRecord::Base.establish_connection(
      :database => 'simply_news',
      :adapter => 'postgresql'
  )

  set :views, File.expand_path('../../views', __FILE__)
  set :public_dir, File.expand_path('../../public', __FILE__)

  #this will go in ApplicationController
  enable :sessions

  def does_account_exist(email)
    account = Account.find_by(:email => email)
    if account
      return true
    else
      return false
    end
  end

  #is accountholder authenticated?
  def is_authenticated?
    if session[:current_account].nil? == true
      puts 'nil'
      return false
    else
      puts "true"
      return true
    end
  end

  def account
    return session[:current_account]
  end

  #is accountholder authorized?
  def authorization_check
    if is_authenticated? == false
      redirect '/not_found'
    else
      return true
    end
  end

  not_found do
      erb :not_found
  end

end # end of ApplicationController
