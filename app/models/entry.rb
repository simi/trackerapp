class Entry < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  attr_accessible :username, :description, :project_id, :minutes, :user_id, :date, :time_spent, :project_name
  attr_accessor :time_spent, :project_name
  
  validates :date, presence: true, :allow_nil => false
  validates :project_id, :minutes, presence: true, :allow_nil => false, allow_blank: false, :numericality => {:greater_than => 0}

  def formatted_minutes
    "#{self.minutes / 60}: #{self.minutes % 60}"
  end

end
