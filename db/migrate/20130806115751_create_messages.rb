class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :sender, index: true, null: false
      t.references :recipient, index: true, null: false
      t.text :content, null: false
      t.string :state, null: false

      t.timestamps
    end
  end
end
