FactoryBot.define do
  factory :clinic do
    sequence(:name) { |n| "Generic Clinic #{n}" }
    sequence(:slug) { |n| "clinic_#{n}" }
    time_zone { nil }
    locale { nil }
  end
end
