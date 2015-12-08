class AccountController < ApplicationController

get '/register' do
  erb :register
end

post '/register' do
  p params
# calls method with arg of username from register form

  if does_account_exist(params[:email]) == true
    return { :message => 'email does exist'}.to_json
  end

account = Account.create(first_name: params[:first_name], email: params[:email], password: params[:password])
p account

session[:current_account] = account
 redirect '/'
end

get '/login' do
  erb :login
end

post '/login' do
account = Account.authenticate(params[:email], params[:password])
  if account
    session[:account] = account
    redirect '/'
  else
    @message = 'Sorry. Email or password not found. Please Try again.'
    erb :login
    end
  end

get '/' do
  authorization_check
  @account = session[:current_account]
  @sources = @account.sources
  erb :login
end

get '/authorization_check' do
  erb :not_found
  end
end

get '/logout' do
  authorization_check
  session[:current_account] = nil
  redirect '/'
  end
end
