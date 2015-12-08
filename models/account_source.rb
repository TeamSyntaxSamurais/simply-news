class Account_Source < ActiveRecord::Base
  belongs_to :account
  belongs_to :source
end
