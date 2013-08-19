class CreateDateRanks < ActiveRecord::Migration
  def change
    create_table :date_ranks do |t|
      t.references :user, index: true, null: false
      t.references :invitation, index: true, null: false
      t.references :courtesy_rank, index: true, null: false
      t.references :punctuality_rank, index: true, null: false
      t.references :authenticity_rank, index: true, null: false

      t.timestamps
    end
  end
end
