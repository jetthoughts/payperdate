class RenameUsersCommunicationToUsersDate < ActiveRecord::Migration
  def change
    rename_table :users_communications, :users_dates
  end
end
