class AddAvatarToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :avatar_id, :integer
  end
end
