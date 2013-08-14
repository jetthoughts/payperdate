class RemoveMultiselectColumnsFromProfile < ActiveRecord::Migration
  def change
    remove_column :profiles, :personal_preferences_partners_sex, :string
    remove_column :profiles, :personal_preferences_relationship, :string
    remove_column :profiles, :personal_preferences_want_relationship, :string
    remove_column :profiles, :date_preferences_smoker, :string
    remove_column :profiles, :date_preferences_drinker, :string
  end
end
