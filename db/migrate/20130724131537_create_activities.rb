class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :user

      t.integer :subject_id
      t.string :subject_type

      t.string :action
      t.hstore :details

      t.timestamps
    end
  end
end
