require 'spec_helper'

describe "Entries" do
  describe "Not Admin" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @project = FactoryGirl.create(:project, users: [@user])
    end

    it "lists existing entries" do
      login_user_with_request(@user)

      entry = FactoryGirl.create(:entry, project: @project, user: @user)
      entry_previous = FactoryGirl.create(:entry, date: 1.month.ago, project: @project, user: @user)
      entry_old = FactoryGirl.create(:entry, date: 3.month.ago, project: @project, user: @user)
      entry_next = FactoryGirl.create(:entry, date: 1.month.from_now, project: @project, user: @user)

      visit "/"
      page.should have_content(entry.description)
      first(:link, 1.month.ago.strftime("%B")).click
      page.should have_content(entry_previous.description)

      first(:link, 2.month.ago.strftime("%B")).click
      first(:link, 3.month.ago.strftime("%B")).click
      page.should have_content(entry_old.description)

      first(:link, "Track time").click
      page.should have_content(entry.description)

      first(:link, 1.month.from_now.strftime("%B")).click
      page.should have_content(entry_next.description)

    end

    it "creates entry", js: true do
      login_user_manually(@user)

      page.should have_content("0 hours and 0 minutes")

      fill_in 'entry_form_time_spent', with: "1.5 h"
      select @project.name, from: 'entry_form_project_id'
      fill_in 'entry_form_description', with: "test description 5"
      click_button 'Add'
      page.should have_content("test description 5")

      fill_in 'entry_form_time_spent', with: "130"
      select @project.name, from: 'entry_form_project_id'
      fill_in 'entry_form_description', with: "test description 6"
      page.execute_script("$('#entry_form_date').val('#{1.month.ago}');")
      click_button 'Add'
      first(:link, 1.month.ago.strftime("%B")).click
      page.should have_content("test description 6")

      fill_in 'entry_form_time_spent', with: "1:15"
      select @project.name, from: 'entry_form_project_id'
      fill_in 'entry_form_description', with: "test description 7"
      page.execute_script("$('#entry_form_date').val('#{1.month.from_now}');")
      click_button 'Add'
      page.should have_content("test description 5")

      first(:link, 1.month.from_now.strftime("%B")).click
      page.should have_content("test description 7")

    end
  end

  describe "Admin" do
    before(:each) do
      @user = FactoryGirl.build(:admin)
      @project = FactoryGirl.create(:project, users: [@user])
    end

    it "lists existing entries" do
      login_user_with_request(@user)

      entry = FactoryGirl.create(:entry, project: @project, user: @user)
      entry_previous = FactoryGirl.create(:entry, date: 1.month.ago, project: @project, user: @user)
      entry_old = FactoryGirl.create(:entry, date: 3.month.ago, project: @project, user: @user)
      entry_next = FactoryGirl.create(:entry, date: 1.month.ago, project: @project, user: @user)

      visit "/"
      page.should have_content(entry.description)

      first(:link, 1.month.ago.strftime("%B")).click
      page.should have_content(entry_previous.description)

      first(:link, 2.month.ago.strftime("%B")).click
      first(:link, 3.month.ago.strftime("%B")).click
      page.should have_content(entry_old.description)

      first(:link, "Track time").click
      page.should have_content(entry.description)

      first(:link, 1.month.ago.strftime("%B")).click
      page.should have_content(entry_next.description)

    end

    it "creates entry", js: true do
      login_user_manually(@user)

      page.should have_content("0 hours and 0 minutes")

      fill_in 'entry_form_time_spent', with: "1.5 h"
      select @project.name, from: 'entry_form_project_id'
      fill_in 'entry_form_description', with: "test description 5"
      click_button 'Add'
      page.should have_content("test description 5")

      fill_in 'entry_form_time_spent', with: "130"
      select @project.name, from: 'entry_form_project_id'
      fill_in 'entry_form_description', with: "test description 6"
      page.execute_script("$('#entry_form_date').val('#{1.month.ago}');")
      click_button 'Add'
      first(:link, (Date.today - 1.month).strftime("%B")).click
      page.should have_content("test description 6")

      fill_in 'entry_form_time_spent', with: "1:15"
      select @project.name, from: 'entry_form_project_id'
      fill_in 'entry_form_description', with: "test description 7"
      page.execute_script("$('#entry_form_date').val('#{1.month.from_now}');")
      click_button 'Add'
      page.should have_content("test description 5")

      first(:link, (Date.today + 1.month).strftime("%B")).click
      page.should have_content("test description 7")

    end
  end
end

