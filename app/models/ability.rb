class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    cannot :all

    if user.present?
      can :read, Album
      can :read, Photo
      can :create, Album
      can :create, Photo
      can :manage, Album do | subject, params |
        subject.user_id == user.id
      end
      can :manage, Photo do | subject, params |
        subject.user_id == user.id
      end
    end
  end
end
