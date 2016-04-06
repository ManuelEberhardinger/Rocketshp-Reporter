class TimeTracking < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
  validates :user, presence: true
  validates :company, presence: true
  validates :spent_time, presence: true
  validates :hourly_rate, presence: true
  validates :date, presence: true
end
