require 'bcrypt'
class Account < ActiveRecord::Base

 include BCrypt

  #setter
  def password=(pwd)
    self.password_digest = Bcrypt::Password.create(pwd)
  end

  #getter
  def password
    BCrypt::Password.new(self.password_digest)
  end

  def self.authenticate(email, password)
    current_account = Account.find_by(account: account)
  #return current account if passwords match
    if (current_account.password == password)
      return current_account
    else
      return nil
    end
  end
end
