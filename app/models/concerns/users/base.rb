module Users::Base
  extend ActiveSupport::Concern

  included do
    devise :database_authenticatable, :registerable,
      :recoverable, :rememberable, :trackable, :validatable

    # clinics
    has_many :memberships, dependent: :destroy
    has_many :clinics, through: :memberships
    belongs_to :current_clinic, class_name: "Clinic", optional: true
    accepts_nested_attributes_for :current_clinic
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
    first_name.present? && last_name.present? && current_clinic.name.present?
  end

  def send_welcome_email
    UserMailer.welcome(self).deliver_later
  end

  def create_default_clinic
    # This creates a `Membership`, because `User` `has_many :clinics, through: :memberships`
    default_clinic = clinics.create(name: "Your Clinic")
    memberships.find_by(clinic: default_clinic).update role_ids: ["admin"]
    update(current_clinic: default_clinic)
  end

  def multiple_clinics?
    clinics.count > 1
  end

  def one_clinic?
    !multiple_clinics?
  end

  def formatted_email_address
    if details_provided?
      "\"#{first_name} #{last_name}\" <#{email}>"
    else
      email
    end
  end

  def parent_ids_for(role, through, parent)
    parent_id_column = "#{parent}_id"
    key = "#{role.key}_#{through}_#{parent_id_column}s"
    return ability_cache[key] if ability_cache && ability_cache[key]
    role = nil if role.default?
    value = send(through).with_role(role).distinct.pluck(parent_id_column)
    current_cache = ability_cache || {}
    current_cache[key] = value
    update_column :ability_cache, current_cache # rubocop:disable Rails/SkipsModelValidations
    value
  end

  def invalidate_ability_cache
    update_column(:ability_cache, {}) # rubocop:disable Rails/SkipsModelValidations
  end

  def developer?
    return false unless ENV["DEVELOPER_EMAILS"]
    # we use email_was so they can't try setting their email to the email of an admin.
    return false unless email_was
    ENV["DEVELOPER_EMAILS"].split(",").include?(email_was)
  end
end
