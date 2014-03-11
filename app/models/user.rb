class User < ActiveRecord::Base
  authenticates_with_sorcery!
  has_many :entries
  has_many :project_users
  has_many :projects, :through => :project_users

  validates_uniqueness_of :email
  validates_uniqueness_of :username
  validates :username, :email, :presence => true, :allow_nil => false
  validates :password, :presence => true,  :confirmation => true, :on => :create
  validates :password_confirmation, :presence => true, :on => :create
  validates_inclusion_of :language, :in => %w( en cs ), :message => I18n.t("users.language_has_to_be")

  serialize :settings, Hash

  def new_entries
    provider.all
  end

  def type_in_words
    admin? ? I18n.t('users.admin') : I18n.t('users.soldier')
  end

  private
  def provider
    "Entry::#{provider_type.classify}Provider".constantize.new(settings[provider_type.to_sym])
  end

end
