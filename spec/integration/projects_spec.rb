require 'spec_helper'

describe "Project" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @admin = FactoryGirl.create(:admin)
    @project = FactoryGirl.create(:project, users: [@user, @admin])
    @project_no_entries = FactoryGirl.create(:project, users: [@user, @admin])

    login_user_with_request(@admin)
    visit "/admin"
  end

  describe "GET /projects" do
    it "lists existing projects" do
      page.should have_content(@project.name)
      page.should have_content(@project_no_entries.name)
    end

    it "lists entries per project" do
      entry = FactoryGirl.create(:entry, project_id: @project.id, user: @user)
      entry_previous = FactoryGirl.create(:entry, date: 1.month.ago, project: @project, user: @user)
      entry_next = FactoryGirl.create(:entry, date: 1.month.from_now, project: @project, user: @user)

      first(:link, "View").click
      page.should have_content(entry.description)

      first(:link, 1.month.ago.strftime("%B")).click
      page.should have_content(entry_previous.description)

      first(:link, Date.current.strftime("%B")).click
      first(:link, 1.month.from_now.strftime("%B")).click
      page.should have_content(entry_next.description)
    end

    it "shows no entries for project which has none" do
      entry = FactoryGirl.create(:entry, project: @project_no_entries, user: @user)
      entry_previous = FactoryGirl.create(:entry, date: 1.month.ago, project: @project_no_entries, user: @user)
      entry_next = FactoryGirl.create(:entry, date: 1.month.from_now, project: @project_no_entries, user: @user)

      all(:link, 'View')[2].click
      page.should have_content("0 hours and 0 minutes")
    end
  end

  describe "EDIT /projects" do
    it "edit project" do
      all(:link, "Edit")[3].click
      page.should have_content("Update")
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
      first(:link, "Add project").click
      page.should have_content("Add new project")

      fill_in 'project_name', with: "ybersuperproject"
      click_button 'Save'

      page.should have_content("ybersuperproject")
    end
  end
end

