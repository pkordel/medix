class Ability
  include CanCan::Ability
  include Roles::Permit

  def initialize(user)
    if user.present?
      # permit user, through: :memberships, parent: :team

      can :manage, User, id: user.id
      can :destroy, Membership, user_id: user.id

      can :create, Team
    end
  end
end
