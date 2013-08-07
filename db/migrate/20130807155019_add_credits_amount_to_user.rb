class AddCreditsAmountToUser < ActiveRecord::Migration
  def change
    add_column :users, :credits_amount, :integer, null: false, default: 0
  end
end
