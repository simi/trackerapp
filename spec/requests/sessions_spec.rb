require 'spec_helper'

describe "Sessions" do
  it "reports invalid password" do
    @user = FactoryGirl.create(:user)
    visit "/"
    fill_in 'username', with: @user.email
    fill_in 'password', with: "incorrect"
    click_button 'Log in'
    # save_and_open_page
    page.should have_content("Username or password was invalid")
    page.should have_content("Login")
  end

  it "reports invalid username" do
    @user = FactoryGirl.create(:user)
    visit "/"
    fill_in 'username', with: "incorrect"
    fill_in 'password', with: "password"
    click_button 'Log in'
    page.should have_content("Username or password was invalid")
    page.should have_content("Login")
  end

  it "logs user" do
    @user = FactoryGirl.create(:user)
    visit "/"
    fill_in 'username', with: @user.email
    fill_in 'password', with: "secret"
    click_button 'Log in'
    page.should have_content("Logged in!")
    page.should have_content("Track time")
  end

  it "requires admin to see administration" do
    @user = FactoryGirl.create(:user)
    visit "/"
    fill_in 'username', with: @user.email
    fill_in 'password', with: "secret"
    click_button 'Log in'
    page.should have_no_content("My Entries")
    page.should have_no_content("Administration")

    visit "/admin"
    page.should have_content("You must be admin to access this section")
    current_path.should == "/"
  end

  it "shows admin navigation" do
    @user = FactoryGirl.build(:user)
    @user.admin = true
    @user.save
    visit "/"
    fill_in 'username', with: @user.email
    fill_in 'password', with: "secret"
    click_button 'Log in'
    page.should have_content("Track time")
    page.should have_link('Administration')
  end
end
