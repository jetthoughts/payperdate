class SplitSenderStateFromRecipientStateInMessages < ActiveRecord::Migration
  def change
    rename_column :messages, :state, :recipient_state
    add_column :messages, :sender_state, :string, null: false, default: 'sent'
  end
end
