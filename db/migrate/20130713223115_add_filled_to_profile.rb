class AddFilledToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :filled, :boolean
  end
end
