class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :trackable, polymorphic: true, index: true
      t.references :owner,     polymorphic: true, index: true
      t.references :recipient, polymorphic: true, index: true
      t.integer :amount
      t.string :key

      #from credit
      t.string :error
      t.string :state, default: 'pending', null: false
      t.string :transaction_id

      t.timestamps
    end
  end
end
