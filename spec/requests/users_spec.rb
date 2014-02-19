require 'spec_helper'

describe "User" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @admin_user = FactoryGirl.create(:admin)
    @project = FactoryGirl.create(:project)
    project_user = FactoryGirl.build(:ProjectUser)
    project_user.project_id = @project.id
    project_user.user_id = @user.id
    project_user.save
    project_user = FactoryGirl.build(:ProjectUser)
    project_user.project_id = @project.id
    project_user.user_id = @admin_user.id
    project_user.save

    visit "/"
    fill_in 'username', with: @admin_user.username
    fill_in 'password', with: "secret_admin"
    click_button 'Log in'
    visit "/admin/users"
  end

  describe "GET /users" do
    it "lists existing users" do
      page.should have_content("tester")
      page.should have_content("tester_admin")
    end

    it "lists entries per user" do
      entry = FactoryGirl.create(:entry, project_id: @project.id, user_id: @user.id)
      entry_previous = FactoryGirl.create(:entry, date: (Date.today - 1.month).strftime("%d/%m/%Y"), project_id: @project.id, user_id: @user.id)
      entry_next = FactoryGirl.create(:entry, date: (Date.today + 1.month).strftime("%d/%m/%Y"), project_id: @project.id, user_id: @user.id)

      first(:link, "View").click
      page.should have_content(entry.description)

      first(:link, (Date.today - 1.month).strftime("%B %Y")).click
      page.should have_content(entry_previous.description)

      first(:link, (Date.today).strftime("%B %Y")).click
      first(:link, (Date.today + 1.month).strftime("%B %Y")).click
      page.should have_content(entry_next.description)
    end

    it "shows no entries for user who has none" do
      entry = FactoryGirl.create(:entry, project_id: @project.id, user_id: @admin_user.id)
      entry_previous = FactoryGirl.create(:entry, date: (Date.today - 1.month).strftime("%d/%m/%Y"), project_id: @project.id, user_id: @admin_user.id)
      entry_next = FactoryGirl.create(:entry, date: (Date.today + 1.month).strftime("%d/%m/%Y"), project_id: @project.id, user_id: @admin_user.id)

      first(:link, "View").click
      page.should have_content("Total:   0:0")
    end
  end

  describe "EDIT /users" do
    it "shows edit form on Edit click" do
      first(:link, "Edit").click
      page.should have_content("Update User info")
      page.should have_content("Username")
      page.should have_content("Email")
      page.should have_content("Password")
      page.should have_content("Password confirm")
      page.should have_content("Admin?")
    end
  end

  describe "CREATE /users" do
    it "creates user" do
      fill_in 'user_username', with: "supertester"
      fill_in 'user_email', with: "supertester@tester.cz"
      fill_in 'user_password', with: "pida_is_da_best"
      fill_in 'user_password_confirmation', with: "pida_is_da_best"
      click_button 'Save'

      page.should have_content("supertester")
    end
  end
end

