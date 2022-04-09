module CurrentAttributes::Base
  extend ActiveSupport::Concern

  included do
    attribute :user, :clinic, :membership, :ability

    resets do
      Time.zone = nil
    end
  end

  def user=(user)
    super

    if user.present?
      Time.zone = user.time_zone
      self.ability = Ability.new(user)
    else
      Time.zone = nil
      self.ability = nil
    end

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
