class SourceCategory < ActiveRecord::Base
  self.table_name = 'source_categories'
  belongs_to :source
  belongs_to :category
end
