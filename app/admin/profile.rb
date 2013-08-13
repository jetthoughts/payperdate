ActiveAdmin.register Profile do
  config.clear_action_items!

  scope :approve_queue, default: true
  scope :published

  show title: -> p { p.name } do |profile|
    extend ProfilesHelper
    render 'admin/profile/approval_queue_navigation'
    render 'admin/profile/profile'
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
      span do
        link_to 'Delete', delete_admin_user_path(profile.auto_user), method: :delete, class: :button
      end
    end
  end

  index as: :block do |profile|
    extend ProfilesHelper
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
          Profile.moderated_params.each do |param|
            if Profile.profanity_checked_params.include? param
              row param do
                highlight(profile[param], Obscenity.offensive(profile[param]))
              end
            else
              row param
            end
          end
          row :reviewed
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
