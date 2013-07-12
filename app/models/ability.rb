class Ability
  include CanCan::Ability

  def initialize(user)
    cannot :all

    if user.present?
      can :read, Album
      can :read, Photo
      can :create, Album
      can :create, Photo

      can :manage, Profile, user_id: user.id

      can :manage, Album do | subject, params |
        subject.user_id == user.id && !subject.system?
      end

      can :manage, Photo do | subject, params |
        subject.user_id == user.id
      end
    end
  end
end
