class AddPublishedVersionOfProfileToUser < ActiveRecord::Migration
  def change
    add_column :users, :published_profile_id, :integer
    add_column :users, :profile_id, :integer
    remove_column :profiles, :user_id
    add_column :profiles, :reviewed, :boolean
  end
end
