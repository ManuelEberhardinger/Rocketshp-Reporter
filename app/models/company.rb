class Company < ActiveRecord::Base
  has_many :contacts
  has_one :social_id
  validates :name, presence: true, uniqueness: true
end
