class AddFaceScoreToPhotos < ActiveRecord::Migration
  revert AddNudeFieldToPhotos

  def change
    add_column :photos, :face, :boolean, default: nil
    add_column :photos, :nude, :boolean, default: nil
  end
end
