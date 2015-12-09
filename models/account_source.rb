class AccountSource < ActiveRecord::Base
  belongs_to :account
  belongs_to :source
  validates_uniqueness_of :account_id, :scope => :source_id
end
