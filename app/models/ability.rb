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
    end
  end
end
