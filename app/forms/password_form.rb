class PasswordForm < Form

  attr_accessor :id, :password, :password_confirmation

  validates :password, :presence => true,  :confirmation => true, :on => :create

  def initialize(attributes = {})
    return if attributes.blank?

    @user = User.find(attributes[:id])
    attributes.delete(:id)

    store(attributes)
    @user.update(attributes)
  end

  def submit
    valid? && @user.save
  end

end
