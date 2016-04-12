class Post < ActiveRecord::Base
  belongs_to :company
  validates :post_type, presence: true
  validates :start_time, presence: true
  validates :post, presence: true
end
