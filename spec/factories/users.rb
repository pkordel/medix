FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "generic-user-#{n}@example.com" }
    password { "08h4f78hrc0ohw9f8heso" }
    password_confirmation { "08h4f78hrc0ohw9f8heso" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sign_in_count { 1 }
    current_sign_in_at { Time.zone.now }
    last_sign_in_at { 1.day.ago }
    current_sign_in_ip { "127.0.0.1" }
    last_sign_in_ip { "127.0.0.2" }
    time_zone { nil }
    locale { nil }
    after(:create) do |user|
      user.create_default_clinic
    end
  end
end
