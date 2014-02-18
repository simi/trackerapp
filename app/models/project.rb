class Project < ActiveRecord::Base
  has_many :entries
  has_many :project_users
  has_many :users, :through => :project_users

  validates :name, :presence => true, :allow_nil => false

  attr_accessible :name, :user_tokens
  attr_reader :user_tokens

  def user_tokens=(ids)
    self.user_ids = ids.split(",").uniq
  end
end
