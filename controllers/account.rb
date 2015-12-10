class AccountController < ApplicationController

  get '/register' do
    @title = "Register"
    erb :register
  end

  post '/register' do
    # calls method with arg of username from register form

    if does_account_exist(params[:email])
      session[:alert] = 'Your email address is already registered.'
      redirect '/login'
    end

    account = Account.new(first_name: params[:first_name], email: params[:email], password: params[:password])
    account.save

    session[:current_account] = account
    redirect '/choose-sources'
  end

  get '/login' do
    @title = "Login"
    erb :login
  end

  post '/login' do
    if does_account_exist(params[:email])
      account = Account.authenticate(params[:email], params[:password])
      if account
        session[:current_account] = account
        redirect '/'
      else
        session[:alert] = 'Sorry, that email and password combination wasn&rsquo;t found.'
        redirect '/account/login'
      end
    else
      session[:alert] = 'No account was found for that email address.'
      redirect '/account/login'
    end
  end

  get '/logout' do
    session[:current_account] = nil
    redirect '/'
  end

  get '/update' do
    authorization_check
    @account = session[:current_account]
    @title = 'Update Account Info'
    erb :update
  end

  post '/update' do
    @account = Account.find(params[:id])
    if params[:first_name] && params[:first_name] != ''
      @account.first_name = params[:first_name]
    end
    if params[:email] && params[:email] != ''
      @account.email = params[:email]
    end
    if params[:password] && params[:password] != ''
      @account.password = params[:password]
    end
    @account.save
    # return view
    session[:alert] = 'Account updated.'
    erb :message
 end

end # End of AccountController
