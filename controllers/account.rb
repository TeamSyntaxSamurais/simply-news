class AccountController < ApplicationController

  get '/' do
    return 'whoops'
  end

  get '/register' do
    erb :register
  end

  post '/register' do
    p params
  # calls method with arg of username from register form

    if does_account_exist(params[:email]) == true
      session[:alert] = 'Your email address is already registered.'
      redirect '/login'
    end

    account = Account.new(first_name: params[:first_name], email: params[:email], password: params[:password])
    account.save

    session[:current_account] = account
    redirect '/choose-sources'
  end

  get '/login' do
    erb :login
  end

  post '/login' do
    account = Account.authenticate(params[:email], params[:password])
    if account
      session[:current_account] = account
      redirect '/'
    else
      session[:alert] = 'Sorry, that email and password combination wasn&rsquo;t found.'
      erb :login
    end
  end

  get '/authorization_check' do
    erb :not_found
  end

  get '/logout' do
    session[:current_account] = nil
    redirect '/'
  end

end # End of AccountController
