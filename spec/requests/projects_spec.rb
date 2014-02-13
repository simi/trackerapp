require 'spec_helper'

describe "Project" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @admin_user = FactoryGirl.create(:admin)
    @project = FactoryGirl.create(:project)
    @project_2 = FactoryGirl.create(:project)
    project_user = FactoryGirl.build(:ProjectUser)
    project_user.project_id = @project.id
    project_user.user_id = @user.id
    project_user.save

    visit "/"
    fill_in 'username', with: @admin_user.username
    fill_in 'password', with: "secret_admin"
    click_button 'Log in'
    visit "/projects"
  end

  describe "GET /projects" do
    it "lists existing projects" do
      page.should have_content(@project.name)
      page.should have_content(@project_2.name)
    end

    it "lists entries per project" do
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

    it "shows no entries for project which has none" do
      entry = FactoryGirl.create(:entry, project_id: @project_2.id, user_id: @user.id)
      entry_previous = FactoryGirl.create(:entry, date: (Date.today - 1.month).strftime("%d/%m/%Y"), project_id: @project_2.id, user_id: @user.id)
      entry_next = FactoryGirl.create(:entry, date: (Date.today + 1.month).strftime("%d/%m/%Y"), project_id: @project_2.id, user_id: @user.id)

      first(:link, "View").click
      page.should have_content("Total:   0:0")
    end
  end

  describe "EDIT /projects" do
    it "edit project" do
      first(:link, "Edit").click
      page.should have_content("Update Project info")
      page.should have_content("Name")
      page.should have_content("Users")

      fill_in 'project_name', with: "superproject"
      click_button 'Save'

      page.should have_content("Project updated.")
      page.should have_content("superproject")
    end
  end

  describe "CREATE /projects" do
    it "creates project" do
      fill_in 'project_name', with: "ybersuperproject"
      click_button 'Save'

      page.should have_content("ybersuperproject")
    end
  end
end

