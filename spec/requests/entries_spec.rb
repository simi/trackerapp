require 'spec_helper'

describe "Entries" do
  describe "Not Admin" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @project = FactoryGirl.create(:project)
      project_user = FactoryGirl.build(:ProjectUser)
      project_user.project_id = @project.id
      project_user.user_id = @user.id
      project_user.save

      visit "/"
      fill_in 'username', with: @user.email
      fill_in 'password', with: "secret"
      click_button 'Log in'
    end

    it "lists existing entries" do
      entry = FactoryGirl.create(:entry, project_id: @project.id, user_id: @user.id)
      entry_previous = FactoryGirl.create(:entry, date: (Date.today - 1.month).strftime("%d/%m/%Y"), project_id: @project.id, user_id: @user.id)
      entry_old = FactoryGirl.create(:entry, date: (Date.today - 3.month).strftime("%d/%m/%Y"), project_id: @project.id, user_id: @user.id)
      entry_next = FactoryGirl.create(:entry, date: (Date.today + 1.month).strftime("%d/%m/%Y"), project_id: @project.id, user_id: @user.id)

      visit "/"
      page.should have_content(entry.description)
      first(:link, (Date.today - 1.month).strftime("%B")).click
      page.should have_content(entry_previous.description)

      first(:link, (Date.today - 2.month).strftime("%B")).click
      first(:link, (Date.today - 3.month).strftime("%B")).click
      page.should have_content(entry_old.description)

      first(:link, "Track time").click
      page.should have_content(entry.description)

      first(:link, (Date.today + 1.month).strftime("%B")).click
      page.should have_content(entry_next.description)

    end

    it "creates entry", js: true do
      page.should have_content("0 hours and 0 minutes")

      fill_in 'entry_form_time_spent', with: "1.5 h"
      select @project.name, from: 'entry_form_project_id'
      fill_in 'entry_form_description', with: "test description 5"
      save_and_open_page
      click_button 'Add'
      page.should have_content("test description 5")

      fill_in 'entry_form_time_spent', with: "130"
      select @project.name, from: 'entry_form_project_id'
      fill_in 'entry_form_description', with: "test description 6"
      fill_in 'entry_form_date', with: (Date.today - 1.month).strftime("%d/%m/%Y")
      click_button 'Add'
      first(:link, (Date.today - 1.month).strftime("%B")).click
      page.should have_content("test description 6")

      fill_in 'entry_form_time_spent', with: "1:15"
      select @project.name, from: 'entry_form_project_id'
      fill_in 'entry_form_description', with: "test description 7"
      fill_in 'entry_form_date', with: (Date.today + 1.month).strftime("%d/%m/%Y")
      click_button 'Add'
      first(:link, (Date.today - 1.month).strftime("%B")).click
      first(:link, "Tracker").click
      page.should have_content("test description 5")

      first(:link, (Date.today + 1.month).strftime("%B")).click
      page.should have_content("test description 7")

    end
  end

  describe "Admin" do
    before(:each) do
      @user = FactoryGirl.build(:user)
      @user.admin = true
      @user.save
      @project = FactoryGirl.create(:project)
      project_user = FactoryGirl.build(:ProjectUser)
      project_user.project_id = @project.id
      project_user.user_id = @user.id
      project_user.save

      visit "/"
      fill_in 'username', with: @user.email
      fill_in 'password', with: "secret"
      click_button 'Log in'
    end

    it "lists existing entries" do
      entry = FactoryGirl.create(:entry, project_id: @project.id, user_id: @user.id)
      entry_previous = FactoryGirl.create(:entry, date: (Date.today - 1.month).strftime("%d/%m/%Y"), project_id: @project.id, user_id: @user.id)
      entry_old = FactoryGirl.create(:entry, date: (Date.today - 3.month).strftime("%d/%m/%Y"), project_id: @project.id, user_id: @user.id)
      entry_next = FactoryGirl.create(:entry, date: (Date.today + 1.month).strftime("%d/%m/%Y"), project_id: @project.id, user_id: @user.id)

      visit "/"
      page.should have_content(entry.description)

      first(:link, (Date.today - 1.month).strftime("%B")).click
      page.should have_content(entry_previous.description)

      first(:link, (Date.today - 2.month).strftime("%B")).click
      first(:link, (Date.today - 3.month).strftime("%B")).click
      page.should have_content(entry_old.description)

      first(:link, "Track time").click
      page.should have_content(entry.description)

      first(:link, (Date.today + 1.month).strftime("%B")).click
      page.should have_content(entry_next.description)

    end

    it "creates entry", js: true do
      page.should have_content("0 hours and 0 minutes")

      fill_in 'entry_form_time_spent', with: "1.5 h"
      select @project.name, from: 'entry_form_project_id'
      fill_in 'entry_form_description', with: "test description 5"
      click_button 'Add'
      page.should have_content("test description 5")

      fill_in 'entry_form_time_spent', with: "130"
      select @project.name, from: 'entry_form_project_id'
      fill_in 'entry_form_description', with: "test description 6"
      fill_in 'entry_form_date', with: (Date.today - 1.month).strftime("%d/%m/%Y")
      click_button 'Add'
      first(:link, (Date.today - 1.month).strftime("%B")).click
      page.should have_content("test description 6")

      fill_in 'entry_form_time_spent', with: "1:15"
      select @project.name, from: 'entry_form_project_id'
      fill_in 'entry_form_description', with: "test description 7"
      fill_in 'entry_form_date', with: (Date.today + 1.month).strftime("%d/%m/%Y")
      click_button 'Add'
      first(:link, (Date.today - 1.month).strftime("%B")).click
      first(:link, "Track time").click
      page.should have_content("test description 5")

      first(:link, (Date.today + 1.month).strftime("%B")).click
      page.should have_content("test description 7")

    end
  end
end

