class Source < ActiveRecord::Base
  has_many :account_sources
  has_many :accounts, through: :account_sources
end
