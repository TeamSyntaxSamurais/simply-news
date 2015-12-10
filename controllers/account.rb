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
    erb :update
  end

  post '/update' do
      @account = session[:current_account]
      @account.first_name = params[:first_name]
      @account.email = params[:email]
      @account.password = params[:password]
      @account.save
      # return view
      @message = "Account updated"
      erb :message
   end

end # End of AccountController
