class MoveAvatarToUser < ActiveRecord::Migration
  def change
    remove_column :profiles, :avatar_id, :integer
    add_column :users, :avatar_id, :integer
  end
end
