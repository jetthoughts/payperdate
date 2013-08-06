class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.references :credits_package, index: true, null: false
      t.references :user, index: true, null: false
      t.string :state, default: 'pending', null: false
      t.string :error
      t.string :transaction_id
      t.timestamps
    end
    add_column :users, :credits_amount, :decimal, null: false, default: 0
  end
end
