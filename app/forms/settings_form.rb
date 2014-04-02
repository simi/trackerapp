class SettingsForm < Form

  attr_accessor :id, :username, :email, :language

  validates_inclusion_of :language, :in => %w( en cs ), :message => I18n.t("users.language_has_to_be")
  validates :username, presence: true
  validates :email, presence: true
  validate :username_is_unique
  validate :email_is_unique

  def initialize(user, attributes = {})
    # return if attributes.blank?

    @user = user

    if attributes == {}
      attributes[:username] = @user.username
      attributes[:email] = @user.email
      attributes[:language] = @user.language
    end

    store(attributes)
    @user.update(attributes)
  end

  def submit
    valid? && @user.save
  end

  private

  def username_is_unique
    unless User.where.not(:id => @user.id).where(:username => @user.username).count == 0
      errors.add(:username, I18n.t('errors.messages.taken'))
    end
  end

  def email_is_unique
    unless User.where.not(:id => @user.id).where(:email => @user.email).count == 0
      errors.add(:email, I18n.t('errors.messages.taken'))
    end
  end

end
