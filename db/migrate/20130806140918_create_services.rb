class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :key
      t.string :name
      t.money :cost
      t.boolean :use_credits

      t.timestamps
    end
  end
end
