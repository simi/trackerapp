class SessionsController < ApplicationController
  def new
  end

  def create
    user = login(params[:username], params[:password], params[:remember_me])
    if user
      redirect_back_or_to root_url, :notice => t('messages.logged_in')
    else
      flash.now.alert = t('messages.invalid_credentials')
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_url, :notice => t('messages.logged_out')
  end
end
