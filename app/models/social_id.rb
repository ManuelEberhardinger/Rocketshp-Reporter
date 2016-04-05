class SocialId < ActiveRecord::Base
  belongs_to :company
  validates :company, presence: true, uniqueness: true
end
