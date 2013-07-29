class CreateProfileNotes < ActiveRecord::Migration
  def change
    create_table :profile_notes do |t|
      t.string :text, null: false
      t.references :profile, null: false
      t.references :admin_user, null: false
      t.timestamps
    end
    add_index :profile_notes, :profile_id
  end
end
