require 'bcrypt'
class Account < ActiveRecord::Base
  self.table_name = 'accounts'

  has_many :account_sources

  include BCrypt

  #setter
  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end

  #getter
  def password
    BCrypt::Password.new(self.password_digest)
  end

  def self.authenticate(email, password)
    current_account = Account.find_by(email: email)
  #return current account if passwords match
    if (current_account.password == password)
      return current_account
    else
      return nil
    end
  end
end
