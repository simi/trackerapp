class Entry < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  validates :date, presence: true
  validates :project, presence: true
  validates :user, presence: true
  validates :minutes, presence: true, numericality: true

  scope :for_user, ->(user) { where(user_id: user.id) }
  scope :between, ->(from, to) { where(date: from..to) }
  scope :by_date, -> { order('date asc') }

end
