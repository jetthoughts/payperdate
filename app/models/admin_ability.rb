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

          can :read, Profile
          can :approve, Profile
        end
        if admin.get_permissions[:permission_customer_care]
          can :read, User
          can :block, User
          can :delete, User
          can :restore, User

          can :manage, Profile
          can :read, Profile
          can :approve, Profile
          can :update, Profile

          can :manage, MemberReport
        end
        if admin.get_permissions[:permission_login_as_user]
          can :read, User
          can :login, User

          can :manage, Profile
        end
        if admin.get_permissions[:permission_gifts_winks_dates]
          can :manage, GiftTemplate
          can :manage, Gift
          can :manage, WinkTemplate
          can :manage, Wink
          can :manage, UsersDate
        end
        if admin.get_permissions[:permission_mass_mailing]
          can [:send_message, :read], ActiveAdmin::Page, name: "Mass Mailing"
        end
        if admin.get_permissions[:permission_accounting]
          can :manage, CreditsPackage
          can :manage, Transaction
          can :manage, Service
          can :manage, CommunicationCost
        end
      end

      can :read, ActiveAdmin::Page, name: 'Dashboard'
    end
  end
end
