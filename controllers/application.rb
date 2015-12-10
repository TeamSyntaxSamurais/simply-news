class ApplicationController < Sinatra::Base

  require 'bundler'
  Bundler.require

  ActiveRecord::Base.establish_connection(
      :database => 'simply_news',
      :adapter => 'mysql2',
      :username => "root",
      :password => "password"
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
      return false
    else
      return true
    end
  end

  def account
    return session[:current_account]
  end

  def account_record
    authorization_check
    return Account.find(session[:current_account].id)
  end

  #is accountholder authorized?
  def authorization_check
    if is_authenticated? == false
      redirect '/account/login'
    else
      return true
    end
  end

  not_found do
    @title = 'Now You&rsquo;ve Done It'
    erb :not_found
  end

end # end of ApplicationController
