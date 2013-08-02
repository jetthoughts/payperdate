class CreateGifts < ActiveRecord::Migration
  def change
    create_table :gifts do |t|
      t.references :gift_template, index: true
      t.references :user, index: true
      t.references :recipient, index: true
      t.string :comment
      t.boolean :private, null: false, default: false

      t.timestamps
    end
  end
end
