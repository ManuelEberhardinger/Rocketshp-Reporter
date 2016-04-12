class Company < ActiveRecord::Base
  has_many :contacts, dependent: :destroy
  has_one :social_id, dependent: :destroy
  has_many :time_trackings, dependent: :destroy
  has_many :posts, dependent: :destroy
  validates :name, presence: true, uniqueness: true
end
