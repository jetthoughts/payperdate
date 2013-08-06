class CreateWinkTemplates < ActiveRecord::Migration
  def change
    create_table :wink_templates do |t|
      t.string :name, null: false
      t.string :image, null: false
      t.boolean :disabled, null: false, default: false
      t.timestamps
    end
    add_index :wink_templates, :name, unique: true
  end
end
