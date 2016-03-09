class FacebookLike < ActiveRecord::Base
  validates :date, uniqueness: true
  validates :page_id, presence: true
end
