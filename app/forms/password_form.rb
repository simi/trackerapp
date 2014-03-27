class PasswordForm < Form

  attr_accessor :id, :password, :password_confirmation

  validates :password, :presence => true,  :confirmation => true, :on => :create

  def initialize(attributes = {}, current_user = nil)
    return if attributes.blank?

    @user = current_user

    store(attributes)
    @user.update(attributes)
  end

  def submit
    valid? && @user.save
  end

end
