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

def does_email_exist(email)
  user = Account.find_by(:email => email)
  if user
    return true
  else
    return false
  end
end

def authorization_check
if session[:current_emaill] == nil
  redirect '/not_found'
else
  return true
end
end

not_found do
  erb :not_found
end # end of ApplicationController
