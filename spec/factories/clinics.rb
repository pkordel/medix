FactoryBot.define do
  factory :clinic do
    sequence(:name) { |n| "Generic Clinic #{n}" }
    sequence(:slug) { |n| "clinic_#{n}" }
  end
end
