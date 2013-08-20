class CreateCommunicationCosts < ActiveRecord::Migration
  def change
    create_table :communication_costs do |t|
      t.money :start_amount
      t.money :end_amount
      t.integer :cost

      t.timestamps
    end
  end
end
