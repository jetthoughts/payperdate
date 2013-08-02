ActiveAdmin.register Profile do
  scope :approve_queue, default: true
  scope :published

  show title: -> p { p.name } do |profile|
    extend ProfilesHelper
    unless profile.reviewed?
      div class: 'profile-grid' do
        div class: 'profile-col-1-3' do
          prev_profile = profile.prev_queued_for_approval
          prev_title = profile.prev_queued_for_approval.nil? ? 'List' : 'Next'
          next_profile = profile.next_queued_for_approval
          next_title = profile.next_queued_for_approval.nil? ? 'List' : 'Prev'
          span do
            link_to next_title, admin_profile_path(next_profile), class: :button
          end
          unless prev_profile.nil? && next_profile.nil?
            span do
              link_to prev_title, admin_profile_path(prev_profile), class: :button
            end
          end
        end
      end
      br
    end
    div class: 'profile-grid' do
      div class: 'profile-col-1-2' do
        h3 do
          span do
            'Main Profile Info'
          end
          if profile.profane?
            span 'Profane!', class: 'profile-label-danger'
          end
        end
        panel 'Profile Info' do
          attributes_table_for profile do
            row :auto_user
            select_row :personal_preferences_sex, 'sex'
            select_row :personal_preferences_partners_sex, 'sex'
            row :optional_info_age do
              span profile.optional_info_age
              em '(here should be birthday, planned in #53)'
            end
            select_row :personal_preferences_relationship, 'relationship'
            select_row :personal_preferences_want_relationship, 'want_relationship'
          end
        end
        panel 'Essays' do
          form_for profile, url: admin_profile_path(profile) do |f|
            strong 'Marked words are possible profane' if profile.profane?
            span do
              link_to 'Edit', '#', class: 'profile-inline-edit-activate'
            end
            attributes_table_for profile do
              row_with_profanity :general_info_tagline
              row :general_info_tagline_edit, class: 'profile-hide profile-inline-edit' do
                f.text_field :general_info_tagline, class: 'profile-hide profile-inline-edit'
              end
              row_with_profanity :general_info_description
              row :general_info_description_edit, class: 'profile-hide profile-inline-edit' do
                f.text_area :general_info_description, class: 'profile-hide profile-inline-edit',
                            rows: 5
              end
              row_with_profanity :date_preferences_description
              row :date_preferences_description_edit, class: 'profile-hide profile-inline-edit' do
                f.text_area :date_preferences_description, class: 'profile-hide profile-inline-edit',
                            rows: 5
              end
              row 'Submit', class: 'profile-hide profile-inline-edit' do
                f.submit class: 'button'
              end
            end
          end
        end
        panel 'Physical Features' do
          attributes_table_for profile do
            row :optional_info_height do
              "#{profile.optional_info_height} cm" unless profile.optional_info_height.blank?
            end
            select_row :optional_info_body_type, 'body_type'
            select_row :optional_info_hair_color, 'hair_color'
            select_row :optional_info_eye_color, 'eye_color'
          end
        end
        panel 'Matches' do
          attributes_table_for profile do
            row :date_preferences_accepted_distance_do_care
            if profile.distance_do_care?
              row :date_preferences_accepted_distance do
                "#{profile.date_preferences_accepted_distance} miles"
              end
            end
            select_row :date_preferences_smoker, 'smoker'
            select_row :date_preferences_drinker, 'drinker'
          end
        end
        panel 'Social' do
          attributes_table_for profile do
            row :optional_info_occupation
            row :optional_info_annual_income do
              unless profile.optional_info_annual_income.blank?
                "#{profile.optional_info_annual_income}$ per year"
              end
            end
            row :optional_info_net_worth do
              unless profile.optional_info_net_worth.blank?
                "#{profile.optional_info_net_worth}$"
              end
            end
          end
        end
      end
      div class: 'profile-col-1-3' do
        h3 'Profile Summary'
        panel 'Summary' do
          div class: 'profile-grid' do
            div class: 'profile-col-2-3' do
              strong profile.auto_user.name
              span "#{profile.optional_info_age || '??'} y/o"
              br
              div 'from'
              strong profile.full_address
              br
              div 'Status:'
              strong 'Active' unless profile.auto_user.blocked?
              strong 'Suspended' if profile.auto_user.blocked?
              br
              div 'Last activity:'
              activity = profile.auto_user.activities.last
              if activity
                strong "#{distance_of_time_in_words activity.created_at, Time.now} ago"
              else
                span '-'
              end
              br
              span "Join date: #{profile.created_at.to_date}"
            end
            div class: 'profile-col-1-3' do
              render 'profile/avatar', profile: profile
            end
          end
        end
      end
    end
  end

  member_action :approve, method: :put do
    profile = Profile.find params[:id]
    authorize! :approve, Profile
    profile.approve!
    redirect_to admin_profiles_path
  end

  action_item only: :show do
    unless profile.reviewed?
      span do
        link_to 'Approve', approve_admin_profile_path(profile), method: :put, class: :button
      end
    end
    # FIXME: it is ugly
    begin
      authorize! :block, User
      authorized_to_block_user = true
    rescue
      authorized_to_block_user = false
    end
    # /FIXME
    if authorized_to_block_user
      span do
        if profile.auto_user.blocked?
          link_to 'Unblock', unblock_admin_user_path(profile.auto_user), method: :put, class: :button
        else
          link_to 'Block', block_admin_user_path(profile.auto_user), method: :put, class: :button
        end
      end
    end
  end

  index as: :block do |profile|
    div for: profile do
      br
      h2 do
        span do
          auto_link profile.name
        end
        if profile.profane?
          span 'Profane!', class: 'profile-label-danger'
        end
      end
      div do
        attributes_table_for profile do
          rows :full_address, :general_info_tagline, :general_info_description,
               :personal_preferences_sex, :date_preferences_description, :reviewed
          row :possible_profanity do
            profile.profane?
          end
        end
      end
      div do
        span do
          link_to 'View', admin_profile_path(profile), class: :button
        end
        unless profile.reviewed?
          span do
            link_to 'Approve', approve_admin_profile_path(profile), method: :put, class: :button
          end
        end
        span do
          link_to 'Edit', edit_admin_profile_path(profile), class: :button
        end
      end
    end
  end

  sidebar :summary, only: [:edit] do
    render 'admin/profiles/summary', profile: resource
    render 'admin/profile_notes/list', profile: resource
  end
end
