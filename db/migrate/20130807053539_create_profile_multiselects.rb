class CreateProfileMultiselects < ActiveRecord::Migration
  def change
    create_table :profile_multiselects do |t|
      t.integer :profile_id
      t.string :name
      t.string :select_type
      t.string :value
      t.boolean :checked

      t.timestamps
    end
  end
end
