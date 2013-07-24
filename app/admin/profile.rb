ActiveAdmin.register Profile do
  scope :approve_queue, default: true
  scope :published

  show title: -> p { p.name } do
    'here be dragons until #36/#39'
  end

  member_action :approve, method: :put do
    profile = Profile.find params[:id]
    authorize! :approve, Profile
    profile.approve!
    redirect_to admin_profiles_path
  end

  index as: :block do |profile|
    div for: profile do
      br
      h2 auto_link profile.name
      div do
        attributes_table_for profile do
          rows :full_address_saved, :general_info_tagline, :general_info_description,
               :personal_preferences_sex, :date_preferences_description, :reviewed
          row :possible_profanity do
            profile.profane?
          end
        end
      end
      div do
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
