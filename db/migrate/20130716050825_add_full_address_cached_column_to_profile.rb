class AddFullAddressCachedColumnToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :full_address_saved, :string
  end
end
