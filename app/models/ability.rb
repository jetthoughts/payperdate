class Ability
  include CanCan::Ability

  def initialize(user)
    cannot :all

    if user.present?
      can :read, Album
      can :read, Photo

      can :create, Album
      can :create, Photo

      can :manage, Album, user_id: user.id, system: false
      can :manage, Photo, user_id: user.id
      can :manage, Avatar, user_id: user.id
      can :manage, Profile, user_id: user.id

      can :invite, User do |u|
        user.can_invite?(u)
      end
      can :destroy, Invitation do |invitation|
        invitation.can_be_deleted_by?(user)
      end
      can :reject, Invitation do |invitation|
        invitation.can_be_rejected_by?(user)
      end
      can :accept, Invitation do |invitation|
        invitation.can_be_accepted_by?(user)
      end
      can :counter, Invitation do |invitation|
        invitation.can_be_countered_by?(user)
      end

      can :send_wink, User do |u|
        user.can_wink?(u)
      end

    end
  end
end
