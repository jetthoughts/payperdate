class RenameGiftsToGiftTemplatesAndChangeStateToNotNull < ActiveRecord::Migration
  def change
    rename_table :gifts, :gift_templates
    change_column :gift_templates, :state, :string, null: false, default: 'enabled'
  end
end
