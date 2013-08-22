class InitEnumTypes < ActiveRecord::Migration
  def up
    create_enum_type :gender,            ["", :female, :male]
    create_enum_type :relationship,      ["", :single, :divorced, :widowed, :married,
                                          :separated, :dating, :cohabiting]
    create_enum_type :want_relationship, ["", :short_term_relationship, :date, :friendship,
                                          :activity_partner]
    create_enum_type :smoker,            ["", :smoker, :non_smoker, :occasional_smoker, :dont_care]
    create_enum_type :me_smoker,         ["", :smoker, :non_smoker, :occasional_smoker]
    create_enum_type :drinker,           ["", :drink_every_night, :occasionally, :non_drinker, :dont_care]
    create_enum_type :me_drinker,        ["", :drink_every_night, :occasionally, :non_drinker]
    create_enum_type :education,         ["", :high_school, :some_college, :associates_degree,
                                          :bachelors_degree, :graduate_degree, :post_doctoral]
    create_enum_type :body_type,         ["", :slim_slender, :athletic, :average, :a_few_extra_pounds,
                                          :full_overweight]
    create_enum_type :religion,          ["", :agnostic, :buddhist, :christian, :hindu, :jewish, :muslim,
                                          :other_religion]
    create_enum_type :ethnicity,         ["", :asian, :black_african_descent, :latin_hispanic, :east_indian,
                                          :middle_eastern, :mixed_race, :native_american,
                                          :pacific_islander, :white_caucasian, :other_ethnicity]
    create_enum_type :eye_color,         ["", :black_eyes, :blue_eyes, :brown_eyes, :gray_eyes, :green_eyes,
                                          :other_eyes]
    create_enum_type :hair_color,        ["", :auburn_hair, :black_hair, :blonde_hair, :dark_blonde_hair,
                                          :light_brown_hair, :dark_brown_hair, :gray_hair, :red_hair,
                                          :white_hair, :other_hair]
    create_enum_type :children,          ["", :no_children, :has_1_child, :has_2_children, :has_3_child,
                                          :greater_3_children]
    create_enum_type :height,            ["", :lower_140_cm, :height_140_150_cm, :height_150_160_cm,
                                          :height_160_165_cm, :height_165_170_cm, :height_170_175_cm,
                                          :height_175_180_cm, :height_180_185_cm, :height_185_190_cm,
                                          :height_190_195_cm, :height_195_200_cm, :greater_200_cm]
    create_enum_type :income,            ["", :lower_10_000_bucks_per_year,
                                          :income_10_000_30_000_bucks_per_year,
                                          :income_30_000_50_000_bucks_per_year,
                                          :income_50_000_70_000_bucks_per_year,
                                          :income_70_000_100_000_bucks_per_year,
                                          :income_100_000_150_000_bucks_per_year,
                                          :income_150_000_500_000_bucks_per_year,
                                          :ok_i_m_very_wealthy]
    create_enum_type :net_worth,         ["", :lower_50_000_bucks, :worth_50_000_150_000_bucks,
                                          :worth_150_000_250_000_bucks, :worth_250_000_350_000_bucks,
                                          :worth_350_000_500_000_bucks, :worth_500_000_1_500_000_bucks,
                                          :worth_1_500_000_5_000_000_bucks, :ok_i_m_very_wealthy]
    load_enum_types_and_hack_active_record
  end

  def down
    drop_enum_type :gender
    drop_enum_type :relationship
    drop_enum_type :want_relationship
    drop_enum_type :smoker
    drop_enum_type :me_smoker
    drop_enum_type :drinker
    drop_enum_type :me_drinker
    drop_enum_type :education
    drop_enum_type :body_type
    drop_enum_type :religion
    drop_enum_type :ethnicity
    drop_enum_type :eye_color
    drop_enum_type :hair_color
    drop_enum_type :children
    drop_enum_type :height
    drop_enum_type :income
    drop_enum_type :net_worth
  end
end
