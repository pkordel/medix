module Users::Base
  extend ActiveSupport::Concern

  included do
    include Roles::User

    devise :database_authenticatable, :registerable,
      :recoverable, :rememberable, :trackable, :validatable

    # teams
    has_many :memberships, dependent: :destroy
    has_many :teams, through: :memberships
    belongs_to :current_team, class_name: "Team", optional: true
    accepts_nested_attributes_for :current_team
  end

  def label_string
    name
  end

  def name
    full_name.presence || email
  end

  def full_name
    [first_name_was, last_name_was].select(&:present?).join(" ")
  end

  def details_provided?
    first_name.present? && last_name.present? && current_team.name.present?
  end

  def send_welcome_email
    UserMailer.welcome(self).deliver_later
  end

  def create_default_team
    # This creates a `Membership`, because `User` `has_many :teams, through: :memberships`
    # TODO The team name should take into account the user's current locale.
    default_team = teams.create(name: "Your Team")
    memberships.find_by(team: default_team).update role_ids: [Role.admin.id]
    update(current_team: default_team)
  end

  def multiple_teams?
    teams.count > 1
  end

  def one_team?
    !multiple_teams?
  end

  def formatted_email_address
    if details_provided?
      "\"#{first_name} #{last_name}\" <#{email}>"
    else
      email
    end
  end

  def administrating_team_ids
    parent_ids_for(Role.admin, :memberships, :team)
  end

  def parent_ids_for(role, through, parent)
    parent_id_column = "#{parent}_id"
    key = "#{role.key}_#{through}_#{parent_id_column}s"
    return ability_cache[key] if ability_cache && ability_cache[key]
    role = nil if role.default?
    value = send(through).with_role(role).distinct.pluck(parent_id_column)
    current_cache = ability_cache || {}
    current_cache[key] = value
    update_column :ability_cache, current_cache
    value
  end

  def invalidate_ability_cache
    update_column(:ability_cache, {})
  end

  def developer?
    return false unless ENV["DEVELOPER_EMAILS"]
    # we use email_was so they can't try setting their email to the email of an admin.
    return false unless email_was
    ENV["DEVELOPER_EMAILS"].split(",").include?(email_was)
  end
end
