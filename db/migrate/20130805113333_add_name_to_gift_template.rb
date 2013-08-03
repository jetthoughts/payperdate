class AddNameToGiftTemplate < ActiveRecord::Migration
  def change
    add_column :gift_templates, :name, :string
  end
end
