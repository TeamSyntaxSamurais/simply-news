class Category < ActiveRecord::Base
  self.table_name = 'categories'
  has_many :source_categories
  has_many :sources, through: :source_categories
end
