class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      can :manage, User, id: user.id
      can :destroy, Membership, user_id: user.id

      can :create, Clinic
    end
  end
end
