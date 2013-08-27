class RenameInvitationToUsersDateInDateRanks < ActiveRecord::Migration
  def change
    rename_column :date_ranks, :invitation_id, :users_date_id
  end
end
