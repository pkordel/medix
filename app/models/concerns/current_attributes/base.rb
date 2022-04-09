module CurrentAttributes::Base
  extend ActiveSupport::Concern

  included do
    attribute :user, :clinic, :membership, :ability
  end

  def user=(user)
    super

    self.ability = Ability.new(user) if user.present?

    update_membership
  end

  def clinic=(clinic)
    super
    update_membership
  end

  def update_membership
    self.membership = if user && clinic
      user.memberships.where(clinic: clinic)
    end
  end
end
