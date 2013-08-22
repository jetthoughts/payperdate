require 'payperdate/postgres_enum'
load_enum_types_and_hack_active_record

require_relative '20130807053539_create_profile_multiselects'

class ChangeSelectFieldsToEnums < ActiveRecord::Migration
  def change
    revert CreateProfileMultiselects

    enums = reload_enums

    profile_fields_to_be_enums = {
      personal_preferences_sex: :gender,
      optional_info_education: :education,
      optional_info_annual_income: :income,
      optional_info_net_worth: :net_worth,
      optional_info_height: :height,
      optional_info_body_type: :body_type,
      optional_info_religion: :religion,
      optional_info_ethnicity: :ethnicity,
      optional_info_eye_color: :eye_color,
      optional_info_hair_color: :hair_color,
      optional_info_children: :children,
      optional_info_smoker: :me_smoker,
      optional_info_drinker: :me_drinker
    }

    profile_ordinary_preferences = {
    }

    profile_multiselect_preferences = {
      personal_relationship: :relationship,
      personal_want_relationship: :want_relationship,
      personal_partners_sex: :gender,
      date_smoker: :smoker,
      date_drinker: :drinker
    }

    profile_fields_to_be_enums.each do |name, enum_name|
      remove_column :profiles, name, :string
      add_column :profiles, name, :"enum_#{enum_name}"
    end

    create_table :profile_preferences do |t|
      # t.references :profile

      profile_ordinary_preferences.each do |name, type|
        t.column name, type
      end

      profile_multiselect_preferences.each do |name, enum_name|
        enums[enum_name.to_s].each do |enum_value|
          t.boolean :"#{name}_is_#{enum_value}"
        end
      end

      t.timestamps
    end

    add_column :profiles, :profile_preference_id, :integer
  end
end
