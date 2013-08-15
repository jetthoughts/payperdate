class AddColumnDeletedReasonToUser < ActiveRecord::Migration
  def change
    add_column :users, :deleted_reason, :string
  end
end
