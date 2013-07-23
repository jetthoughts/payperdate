class AddAbuseFlagAndBlockedFlagToUser < ActiveRecord::Migration
  def change
    add_column :users, :abuse, :boolean
    add_column :users, :blocked, :boolean
  end
end
