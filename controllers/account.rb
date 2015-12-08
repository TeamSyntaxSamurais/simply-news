class AccountController < ApplicationController


#Registration & Login
get '/acccount_entry' do
  erb :acccount_entry
end

post 'acccount_entry' do
  p params
  if does_user_exist(params[:first_name]) == true
    return { :message => 'user does exist'}.to_json
  end

user = Account.
