class CreateMemberReports < ActiveRecord::Migration
  def change
    create_table :member_reports do |t|
      t.references :user, index: true, null: false
      t.references :reported_user, index: true, null: false
      t.references :content, index: true, null: false, polymorphic: true
      t.string :message, null: false
      t.string :state, null: false, default: 'active'

      t.timestamps
    end
  end
end
