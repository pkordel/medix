module Memberships::Base
  extend ActiveSupport::Concern

  included do
    # See `docs/permissions.md` for details.
    include Roles::Support

    belongs_to :user, optional: true
    belongs_to :team

    after_destroy do
      # if we're destroying a user's membership to the team they have set as
      # current, then we need to remove that so they don't get an error.
      if user&.current_team == team
        user.current_team = nil
        user.save
      end
    end

    scope :current, -> { where.not(user_id: nil) }
  end

  def name
    full_name
  end

  def label_string
    full_name
  end

  # we overload this method so that when setting the list of role ids
  # associated with a membership, admins can never remove the last admin
  # of a team.
  def role_ids=(ids)
    # if this membership was an admin, and the new list of role ids don't include admin.
    if admin? && ids.exclude?(Role.admin.id)
      unless team.admins.count > 1
        raise RemovingLastTeamAdminException.new("You can't remove the last team admin.")
      end
    end

    super(ids)
  end

  def last_admin?
    return false unless admin?
    return false if user.blank?
    team.memberships.current.select(&:admin?) == [self]
  end

  def nullify_user
    if last_admin?
      raise RemovingLastTeamAdminException.new("You can't remove the last team admin.")
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
        current_team: user_was.teams.first
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

  # TODO utilize this.
  # members shouldn't receive notifications unless they are either an active user or an outstanding invitation.
  def should_receive_notifications?
    user.present?
  end
end
