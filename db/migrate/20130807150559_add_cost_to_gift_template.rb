class AddCostToGiftTemplate < ActiveRecord::Migration
  def change
    add_column :gift_templates, :cost, :integer, null: false, default: 0
  end
end
