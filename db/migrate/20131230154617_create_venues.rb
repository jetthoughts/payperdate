class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :name
      t.float :rating
      t.string :url
      t.string :address
      t.column :location, :point
      t.column :phones, :text, array: true, default: []
      t.string :source
      t.string :pic_url
      t.string :description
      t.string :external_id
      t.string :category
      t.timestamps
    end
  end
end
