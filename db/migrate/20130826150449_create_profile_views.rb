class CreateProfileViews < ActiveRecord::Migration
  def change
    create_table :profile_views do |t|
      t.references :user, index: true
      t.references :viewed, index: true

      t.timestamps
    end
  end
end
