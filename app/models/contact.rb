class Contact < ActiveRecord::Base
  belongs_to :company
  validates :first_name, presence: true
  validates :company, :presence => true
end
