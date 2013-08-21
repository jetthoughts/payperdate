class AddDeletedStateForUser < ActiveRecord::Migration
  def change
    add_column :users, :deleted_state, :string, default: 'none'
  end
end
