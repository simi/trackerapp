class UsersController < ApplicationController
  before_filter :require_login

  def edit
    @user = current_user

    @password_form ||= PasswordForm.new
    @settings_form ||= SettingsForm.new
  end

  def update_password
    @password_form = PasswordForm.new(password_form_params, current_user)

    if @password_form.submit
      redirect_to settings_path, :notice => t('users.password_changed')
    else
      render :edit
    end
  end

  def update_settings
    @settings_form = SettingsForm.new(settings_form_params, current_user)

    if @settings_form.submit
      redirect_to settings_path, :notice => t('users.settings_updated')
    else
      render :edit
    end
  end

  private

  def password_form_params
    params.require(:user).
      permit(:password, :password_confirmation)
  end

  def settings_form_params
    params.require(:user).
      permit(:username, :email, :language)
  end
end
