FactoryBot.define do
  factory :profile do
    title { "Physician" }
    identifier { SecureRandom.base36 }
    approved { true }
    specializations { [{name: "Proctology", period: "2020-10-20..2065-06-17"}] }
    additional_expertise { [{name: "Sick leave certifications", period: "2020-10-20..2065-06-17"}] }
  end
end
