class Entry < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  attr_accessor :time_spent

  validates :date, presence: true
  validates :project, presence: true
  validates :user, presence: true
  validates :minutes, presence: true, numericality: true

  def formatted_minutes
    "#{self.minutes / 60}: #{self.minutes % 60}"
  end

end
