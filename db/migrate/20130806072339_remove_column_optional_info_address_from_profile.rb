class RemoveColumnOptionalInfoAddressFromProfile < ActiveRecord::Migration
  def change
    remove_column :profiles, :optional_info_address, :string
  end
end
