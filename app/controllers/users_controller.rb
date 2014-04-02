class UsersController < ApplicationController
  before_filter :require_login

  def edit
    @user = current_user

    @settings_form ||= SettingsForm.new(current_user)
    @password_form ||= PasswordForm.new(current_user)
  end

  def update_password
    @user = current_user

    @password_form = PasswordForm.new(current_user, password_form_params)
    @settings_form ||= SettingsForm.new(current_user)

    if @password_form.submit
      redirect_to settings_path, :notice => t('users.password_changed')
    else
      render :edit
    end
  end

  def update_settings
    @user = current_user

    @settings_form = SettingsForm.new(current_user, settings_form_params)
    @password_form ||= PasswordForm.new(current_user)

    if @settings_form.submit
      redirect_to settings_path, :notice => t('users.settings_updated')
    else
      render :edit
    end
  end

  private

  def password_form_params
    params.require(:password_form).
      permit(:password, :password_confirmation)
  end

  def settings_form_params
    params.require(:settings_form).
      permit(:username, :email, :language)
  end
end
