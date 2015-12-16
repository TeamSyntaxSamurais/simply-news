class AccountSource < ActiveRecord::Base
  self.table_name = 'account_sources'
  belongs_to :account
  belongs_to :source
  validates_uniqueness_of :account_id, :scope => :source_id
end
