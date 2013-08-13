class CreateBlockRelationships < ActiveRecord::Migration
  def change
    create_table :block_relationships do |t|
      t.references :user, index: true
      t.references :target, index: true

      t.timestamps
    end
  end
end
