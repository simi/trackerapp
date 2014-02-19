require 'spec_helper'

describe "Sessions" do
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

  it "requires admin to see administration" do
    @user = FactoryGirl.create(:user)
    visit "/"
    fill_in 'username', with: @user.username
    fill_in 'password', with: "secret"
    click_button 'Log in'
    page.should have_no_content("My Entries")
    page.should have_no_content("Administration")

    visit "/admin/projects"
    page.should have_content("You must be admin to access this section")
    current_path.should == "/"

    visit "/admin/users"
    page.should have_content("You must be admin to access this section")
    current_path.should == "/"

  end

  it "shows admin navigation" do
    @user = FactoryGirl.build(:user)
    @user.admin = true
    @user.save
    visit "/"
    fill_in 'username', with: @user.username
    fill_in 'password', with: "secret"
    click_button 'Log in'
    page.should have_content("Log out")

    page.should have_content("My Entries")
    page.should have_content("Administration")
  end
end
