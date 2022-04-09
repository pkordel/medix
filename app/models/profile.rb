class Profile < ApplicationRecord
  has_many :memberships, foreign_key: :current_profile_id, dependent: :nullify, inverse_of: :current_profile
end
