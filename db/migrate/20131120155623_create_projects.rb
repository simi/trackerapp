# Both current users needs to be created before running
# this migration.
class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name

      t.timestamps
    end

    change_table :entries do |t|
      t.rename :user, :username
      t.integer :project_id
      t.integer :user_id
    end

    desks_near_me_project = Project.create(name: 'DesksNearMe')

    Entry.update_all(project_id: desks_near_me_project.id)

    if defined?(USERS_CONFIG)
      USERS_CONFIG.each do |key, array|
        user = User.new(:username => key, :email => array["e-mail"] ,:password => "password", :password_confirmation => "password")
        user.save
      end

      Entry.all.each do |entry|
        entry.user_id = User.find_by(username: entry.username).id
        entry.save
      end
    end

    create_table :project_users do |t|
      t.integer :project_id, :null => false
      t.integer :user_id, :null => false

      t.timestamps
    end

    User.all.each do |user|
      project_user = ProjectUser.new
      project_user.user_id = user.id
      project_user.project_id = desks_near_me_project.id
      project_user.save
    end

    remove_column :entries, :username

  end
end
