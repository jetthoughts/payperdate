class UpdateStateOfUser < ActiveRecord::Migration
  def change
    remove_column :users, :blocked, :boolean
    add_column :users, :state, :string, default: :active
  end
end
