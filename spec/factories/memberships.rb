FactoryBot.define do
  factory :membership do
    association :user
    association :clinic
  end
end
