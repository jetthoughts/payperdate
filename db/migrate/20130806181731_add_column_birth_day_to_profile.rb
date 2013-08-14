class AddColumnBirthDayToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :optional_info_birthday, :date
    remove_column :profiles, :optional_info_age, :integer
  end
end
