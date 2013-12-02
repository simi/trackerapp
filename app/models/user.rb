class User < ActiveRecord::Base
  authenticates_with_sorcery!
  has_many :entries
  has_many :project_users
  has_many :projects, :through => :project_users

  attr_accessible :username, :email, :password, :password_confirmation

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_uniqueness_of :username
end
