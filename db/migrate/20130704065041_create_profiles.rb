class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id, null: false
      t.hstore :general_info
      t.hstore :personal_preferences
      t.hstore :date_preferences
      t.hstore :optional_info

      t.timestamps
    end
    add_index :profiles, :user_id
  end
end
