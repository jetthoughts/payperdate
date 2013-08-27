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

      can :send_wink, User do |u|
        user.can_wink?(u)
      end

      can :communicate, User do |u|
        user.can_communicate_with?(u) && !user.blocked_for?(u)
      end

      can [:read, :destroy], Message do |message|
        user.can_access?(message)
      end

      can :destroy, Invitation do |invitation|
        invitation.can_be_deleted_by?(user)
      end

      can [:reject, :accept], Invitation do |invitation|
        invitation.need_response_from?(user)
      end

      can :counter, Invitation do |invitation|
        invitation.can_be_countered_by?(user)
      end

      can :unlock, UsersDate do |users_date|
        users_date.can_be_unlocked_by?(user)
      end

      can :rank, UsersDate do |users_date|
        users_date.can_be_ranked?(user)
      end

      can :view_rank, UsersDate do |users_date|
        users_date.can_view_rank?(user)
      end

    end
  end
end
