require 'spec_helper'

describe "Entries" do
  describe "GET /entries" do
    it "lists existing entries" do
      user = FactoryGirl.create(:user)
      project = FactoryGirl.create(:project)
      entry = FactoryGirl.create(:entry)
      entry_previous = FactoryGirl.create(:entry, date: (Date.today - 1.month).strftime("%d/%m/%Y"))
      entry_old = FactoryGirl.create(:entry, date: (Date.today - 3.month).strftime("%d/%m/%Y"))
      entry_next = FactoryGirl.create(:entry, date: (Date.today + 1.month).strftime("%d/%m/%Y"))
      FactoryGirl.create(:ProjectUser)

      visit "/"
      fill_in 'username', with: user.username
      fill_in 'password', with: "secret"
      click_button 'Log in'
      page.should have_content("test description 1")

      first(:link, (Date.today - 1.month).strftime("%B %Y")).click
      page.should have_content("test description 2")

      first(:link, (Date.today - 2.month).strftime("%B %Y")).click
      first(:link, (Date.today - 3.month).strftime("%B %Y")).click
      page.should have_content("test description 3")

      first(:link, "Tracker").click
      page.should have_content("test description 1")

      first(:link, (Date.today + 1.month).strftime("%B %Y")).click
      page.should have_content("test description 4")

    end

    it "creates entry" do
      user = FactoryGirl.create(:user)
      project = FactoryGirl.create(:project)
      visit "/"
      fill_in 'username', with: user.username
      fill_in 'password', with: "secret"
      click_button 'Log in'
      page.should have_content("Total:  0:0")

      fill_in 'entry_time_spent', with: "1.5 h"
      fill_in 'entry_project_name', with: "test project"
      fill_in 'entry_description', with: "test description 5"
      click_button 'Add'
      page.should have_content("test description 5")

      fill_in 'entry_time_spent', with: "130"
      fill_in 'entry_project_name', with: "test project"
      fill_in 'entry_description', with: "test description 6"
      fill_in 'entry_date', with: (Date.today - 1.month).strftime("%d/%m/%Y")
      click_button 'Add'
      first(:link, (Date.today - 1.month).strftime("%B %Y")).click
      page.should have_content("test description 6")

      fill_in 'entry_time_spent', with: "1:15"
      fill_in 'entry_project_name', with: "test project"
      fill_in 'entry_description', with: "test description 7"
      fill_in 'entry_date', with: (Date.today + 1.month).strftime("%d/%m/%Y")
      click_button 'Add'
      first(:link, (Date.today - 1.month).strftime("%B %Y")).click
      first(:link, "Tracker").click
      page.should have_content("test description 5")

      first(:link, (Date.today + 1.month).strftime("%B %Y")).click
      page.should have_content("test description 7")

    end
  end
end
