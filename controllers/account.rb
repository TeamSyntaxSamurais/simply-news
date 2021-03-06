class AccountController < ApplicationController

  get '/register' do
    @title = "Register"
    erb :register
  end

  post '/register' do

    ## Alert if email is already in database
    if does_account_exist(params[:email])
      session[:alert] = 'Your email address is already registered.'
      redirect '/account/login'
    end

    ## Create account
    account = Account.new(first_name: params[:first_name], email: params[:email], password: params[:password])
    account.save

    ## Save selected sources to new account
    if session[:sources]
      session[:sources].each do |id|
        account_source = AccountSource.new
        account_source.account_id = account[:id]
        account_source.source_id = id
        account_source.save
      end
    end

    session[:current_account] = account
    session[:alert] = 'Your account&rsquo;s been created.'
    redirect '/feed'
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
        session[:alert] = 'Login successful.'
        redirect '/feed'
      else
        session[:alert] = 'Sorry, that email and password combination wasn&rsquo;t found.'
        redirect '/account/login'
      end
    else
      session[:alert] = 'No account was found for that email address.'
      redirect '/account/login'
    end
  end

  get '/about' do
    @title = "About"
    @account = session[:current_account]
    erb :about
  end

  get '/logout' do
    session[:current_account] = nil
    session[:sources] = nil
    session[:alert] = 'Logout successful.'
    redirect '/feed'
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
    session[:current_account] = @account
    session[:alert] = 'Account updated.'
    redirect '/account/update'
 end

end # End of AccountController
