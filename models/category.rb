class Category < ActiveRecord::Base
  has_many :source_categories
  has_many :sources, through: :source_categories
end
