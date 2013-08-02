class CreateGiftTemplates < ActiveRecord::Migration
  def change
    create_table :gifts do |t|
      t.string :image, null: false
      t.string :state

      t.timestamps
    end
  end
end
