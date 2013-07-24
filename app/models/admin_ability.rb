class AdminAbility
  include CanCan::Ability

  def initialize(admin)
    cannot :all

    if admin.present?
      if admin.master?
        can :manage, :all
      else
        if admin.get_permissions[:permission_approver]
          can :read, Photo
          can :approve, Photo
          can :decline, Photo
        end
        if admin.get_permissions[:permission_customer_care]
          can :read, User
          can :block, User
          can :delete, User
        end
      end

      can :read, ActiveAdmin::Page, name: 'Dashboard'
    end
  end
end
