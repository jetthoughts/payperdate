class AddTypeFieldToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :type, :string, default: 'Photo'
  end
end
