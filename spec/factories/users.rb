FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "generic-user-#{n}@example.com" }
    password { "08h4f78hrc0ohw9f8heso" }
    password_confirmation { "08h4f78hrc0ohw9f8heso" }
    after(:create) do |user|
      user.create_default_team
    end
  end
end
