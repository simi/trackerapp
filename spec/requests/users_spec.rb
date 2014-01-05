require 'spec_helper'

describe "Users" do
  describe "GET /users" do
    it "reports invalid password" do
      @user = FactoryGirl.create(:user)
      visit "/"
      fill_in 'username', with: @user.username
      fill_in 'password', with: "incorrect"
      click_button 'Log in'
      page.should have_content("Username or password was invalid")
      page.should have_content("log in")
    end

    it "reports invalid username" do
      @user = FactoryGirl.create(:user)
      visit "/"
      fill_in 'username', with: "incorrect"
      fill_in 'password', with: "password"
      click_button 'Log in'
      page.should have_content("Username or password was invalid")
      page.should have_content("log in")
    end

    it "logs user" do
      @user = FactoryGirl.create(:user)
      visit "/"
      fill_in 'username', with: @user.username
      fill_in 'password', with: "secret"
      click_button 'Log in'
      page.should have_content("Log out")
    end
  end
end
