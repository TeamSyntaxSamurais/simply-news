class Source < ActiveRecord::Base
  self.table_name = 'sources'
  has_many :account_sources
  has_many :accounts, through: :account_sources
  has_many :source_categories
  has_many :categories, through: :source_categories
end
