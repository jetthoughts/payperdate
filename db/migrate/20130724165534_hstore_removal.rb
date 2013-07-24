class HstoreRemoval < ActiveRecord::Migration
  def change
    remove_column :profiles,:general_info, :hstore
    remove_column :profiles,:personal_preferences, :hstore
    remove_column :profiles,:date_preferences, :hstore
    remove_column :profiles,:optional_info, :hstore

    add_column :profiles, :general_info_address_line_1, :string
    add_column :profiles, :general_info_address_line_2, :string
    add_column :profiles, :general_info_city, :string
    add_column :profiles, :general_info_state, :string
    add_column :profiles, :general_info_zip_code, :string
    add_column :profiles, :general_info_tagline, :string
    add_column :profiles, :general_info_description, :text
    add_column :profiles, :personal_preferences_sex, :string
    add_column :profiles, :personal_preferences_partners_sex, :string
    add_column :profiles, :personal_preferences_relationship, :string
    add_column :profiles, :personal_preferences_want_relationship, :string
    add_column :profiles, :date_preferences_accepted_distance, :string
    add_column :profiles, :date_preferences_accepted_distance_do_care, :string
    add_column :profiles, :date_preferences_smoker, :string
    add_column :profiles, :date_preferences_drinker, :string
    add_column :profiles, :date_preferences_description, :text
    add_column :profiles, :optional_info_age, :integer
    add_column :profiles, :optional_info_education, :string
    add_column :profiles, :optional_info_occupation, :string
    add_column :profiles, :optional_info_annual_income, :string
    add_column :profiles, :optional_info_net_worth, :integer
    add_column :profiles, :optional_info_height, :integer
    add_column :profiles, :optional_info_body_type, :string
    add_column :profiles, :optional_info_religion, :string
    add_column :profiles, :optional_info_ethnicity, :string
    add_column :profiles, :optional_info_eye_color, :string
    add_column :profiles, :optional_info_hair_color, :string
    add_column :profiles, :optional_info_address, :string
    add_column :profiles, :optional_info_children, :string
    add_column :profiles, :optional_info_smoker, :string
    add_column :profiles, :optional_info_drinker, :string
  end
end
