class AdminAbility
  include CanCan::Ability

  def initialize(admin)
    cannot :all

    if admin.present?
      if admin.master
        can :manage, :all
      else
        can :manage, Photo if admin.permissions['approve_photos_avatars'] == '1'
      end
      can :read, ActiveAdmin::Page, :name => "Dashboard"
    end
  end
end
