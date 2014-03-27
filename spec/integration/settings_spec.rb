require 'spec_helper'

describe "Settings" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    login_user_with_request(@user)
  end

  it "shows settings" do
    visit "/settings"
    page.should have_content("Settings")
    page.should have_content("Username")
    page.should have_content("Email")
    page.should have_content("Language")
  end

  it "updates settings" do
    visit "/settings"
    fill_in 'user_username', with: "tester_updated"
    fill_in 'user_email', with: "tester_updated@tester.cz"
    first(:button, "Update").click
    page.should have_field('user_username', :with => 'tester_updated')
    page.should have_field('user_email', :with => 'tester_updated@tester.cz')
  end

  it "changes password" do
    visit "/settings"
    fill_in 'user_password', with: "updated_password"
    fill_in 'user_password_confirmation', with: "updated_password"
    all(:button, 'Update')[1].click
    visit "/logout"
    fill_in 'username', with: @user.email
    fill_in 'password', with: "updated_password"
    click_button 'Log in'
    page.should have_content("Logged in!")
    page.should have_content("Track time")
  end
end
