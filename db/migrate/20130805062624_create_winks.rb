class CreateWinks < ActiveRecord::Migration
  def change
    create_table :winks do |t|
      t.references :wink_template, null: false, index: true
      t.references :user, null: false, index: true
      t.references :recipient, null: false, index: true
      t.timestamps
    end
  end
end
