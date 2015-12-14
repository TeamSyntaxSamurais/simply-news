class SourceCategory < ActiveRecord::Base
  belongs_to :source
  belongs_to :category
end
