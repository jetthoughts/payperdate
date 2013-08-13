class AddColumnNicknameAndNameCacheToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :nickname_cache, :string
    add_column :profiles, :name_cache, :string
    change_column :profiles, :optional_info_height, :string
    change_column :profiles, :optional_info_annual_income, :string
    change_column :profiles, :optional_info_net_worth, :string
  end
end
