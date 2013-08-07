class CreateCreditsPackages < ActiveRecord::Migration
  def change
    create_table :credits_packages do |t|
      t.money :price
      t.integer :credits
      t.string :description

      t.timestamps
    end
  end
end
