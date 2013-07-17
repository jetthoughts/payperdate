class AddDeclinedReasonFieldToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :declined_reason, :integer
  end
end
