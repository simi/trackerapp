class SettingsForm < Form

  attr_accessor :id, :username, :email, :language

  validates_inclusion_of :language, :in => %w( en cs ), :message => I18n.t("users.language_has_to_be")
  validates :username, presence: true
  validates :email, presence: true
  validate :username_is_unique
  validate :email_is_unique

  def initialize(user, attributes = {})
    @user = user

    if attributes.blank?
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
    if not User.where.not(:id => @user.id).where(:username => @user.username).count.zero?
      errors.add(:username, I18n.t('errors.messages.taken'))
    end
  end

  def email_is_unique
    if not User.where.not(:id => @user.id).where(:email => @user.email).count.zero?
      errors.add(:email, I18n.t('errors.messages.taken'))
    end
  end

end
