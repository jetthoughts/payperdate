class AddCommunicationUnlockedToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :communication_unlocked, :boolean, default: false
  end
end
