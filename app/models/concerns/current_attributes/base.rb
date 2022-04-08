module CurrentAttributes::Base
  extend ActiveSupport::Concern

  included do
    attribute :user, :team, :membership, :ability
  end

  def user=(user)
    super

    self.ability = Ability.new(user) if user.present?

    update_membership
  end

  def team=(team)
    super
    update_membership
  end

  def update_membership
    self.membership = if user && team
      user.memberships.where(team: team)
    end
  end
end
