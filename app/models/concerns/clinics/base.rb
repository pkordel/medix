module Clinics::Base
  extend ActiveSupport::Concern

  included do
    # memberships and invitations
    has_many :memberships, dependent: :destroy
    has_many :users, through: :memberships

    # validations
    validates :name, presence: true
  end

  def admins
    memberships.current.admins
  end

  def admin_users
    admins.map(&:user).compact
  end

  def primary_contact
    admin_users.min { |user| user.created_at }
  end

  def formatted_email_address
    primary_contact.email
  end

  def invalidate_caches
    users.map(&:invalidate_ability_cache)
  end

  def clinic
    # some generic features appeal to the `clinic` method for security or scoping purposes, but sometimes those same
    # generic functions need to function for a clinic model as well, so we do this.
    self
  end
end
