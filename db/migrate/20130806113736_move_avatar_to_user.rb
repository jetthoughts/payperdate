class MoveAvatarToUser < ActiveRecord::Migration
  def up
    remove_column :profiles, :avatar_id
    add_column :users, :avatar_id, :integer
  end

  def down
    remove_column :users, :avatar_id
    add_column :profiles, :avatar_id, :integer
  end
end
