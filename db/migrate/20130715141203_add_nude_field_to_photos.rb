class AddNudeFieldToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :nude, :boolean, default: false
    add_column :photos, :nudity, :float
  end
end
