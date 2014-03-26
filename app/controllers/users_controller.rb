class UsersController < ApplicationController
  before_filter :require_login

  def edit
    @user = current_user

    @password_form ||= PasswordForm.new
    @settings_form ||= SettingsForm.new
  end

  def update
    @password_form = PasswordForm.new(password_form_params)
    @settings_form = SettingsForm.new(settings_form_params)

    if @password_form.submit
      redirect_to settings_path, :notice => "password updated"
    elsif @settings_form.submit
      redirect_to settings_path, :notice => "settings updated"
    else
      render :edit
    end
  end

  private

  def password_form_params
    params.require(:user).
      permit(:password, :password_confirmation).
        merge(id: current_user.id)
  end

  def settings_form_params
    params.require(:user).
      permit(:username, :email, :language).
        merge(id: current_user.id)
  end
end
