class AdminAbility
  include CanCan::Ability

  def initialize(admin)
    cannot :all

    if admin.present?
      if admin.master?
        can :manage, :all
      else
        if admin.get_permissions[:permission_approve_photos_avatars]
          can :read, Photo
          can :approve, Photo
          can :decline, Photo
        end
      end
      can :read, ActiveAdmin::Page, :name => "Dashboard"
    end
  end
end
