module Memberships::Base
  extend ActiveSupport::Concern

  included do
    belongs_to :user, optional: true
    belongs_to :clinic
    belongs_to :current_profile, class_name: "Profile", optional: true

    after_destroy do
      # if we're destroying a user's membership to the clinic they have set as
      # current, then we need to remove that so they don't get an error.
      if user&.current_clinic == clinic
        user.current_clinic = nil
        user.save
      end
    end

    scope :current, -> { where.not(user_id: nil) }
    scope :admins, -> { where(role_ids: [Role.admin]) }
    scope :physicians, -> { where(role_ids: [Role.physician]) }
    scope :patients, -> { where(role_ids: [Role.patient]) }
  end

  def name
    full_name
  end

  def label_string
    full_name
  end

  def admin?
    role_ids.include? Role.admin
  end

  def physician?
    role_ids.include? Role.physician
  end

  def patient?
    role_ids.include? Role.patient
  end

  # we overload this method so that when setting the list of role ids
  # associated with a membership, admins can never remove the last admin
  # of a clinic.
  def role_ids=(ids)
    # if this membership was an admin, and the new list of role ids don't include admin.
    if admin? && ids.exclude?("admin")
      unless clinic.admins.count > 1
        raise RemovingLastClinicAdminException.new("You can't remove the last clinic admin.")
      end
    end

    super(ids)
  end

  def last_admin?
    return false unless admin?
    return false if user.blank?
    clinic.memberships.current.select(&:admin?) == [self]
  end

  def nullify_user
    if last_admin?
      raise RemovingLastClinicAdminException.new("You can't remove the last clinic admin.")
    end

    if (user_was = user)
      if user_first_name.blank?
        self.user_first_name = user.first_name
      end

      if user_last_name.blank?
        self.user_last_name = user.last_name
      end

      if user_profile_photo_id.blank?
        self.user_profile_photo_id = user.profile_photo_id
      end

      if user_email.blank?
        self.user_email = user.email
      end

      self.user = nil
      save

      user_was.invalidate_ability_cache

      user_was.update(
        current_clinic: user_was.clinics.first
      )
    end
  end

  def email
    user&.email || user_email.presence
  end

  def full_name
    user&.full_name || [first_name.presence, last_name.presence].join(" ").presence || email
  end

  def first_name
    user&.first_name || user_first_name
  end

  def last_name
    user&.last_name || user_last_name
  end

  def last_initial
    return nil if last_name.blank?
    "#{last_name}."
  end

  def first_name_last_initial
    [first_name, last_initial].map(&:present?).join(" ")
  end

  def approved?
    return false if current_profile.blank?

    current_profile.approved?
  end

  # TODO utilize this.
  # members shouldn't receive notifications unless they are either an active user or an outstanding invitation.
  def should_receive_notifications?
    user.present?
  end
end
