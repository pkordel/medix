clinics = [
  "Ullevål Universitetssykehus",
  "Rikshospitalet Hf",
  "Diakonhjemmet Sykehus",
  "Lovisenberg Diakonale Sykehus",
  "Colosseumklinikken Legeavdeling",
  "St. Hanshaugen",
  "Oslo Universitetssykehus Hf"
]
timezone = "Stockholm"
locale = "nb"
Clinic.create(
  clinics.each_with_object([]) do |clinic, memo|
    memo << {name: clinic, slug: clinic.parameterize, time_zone: timezone, locale: locale}
  end
)

ucla = Clinic.create(
  name: "UCLA Medical Center", slug: "ucla-medical-center",
  time_zone: "Pacific Time (US & Canada)", locale: "en"
)
johns = Clinic.create(
  name: "Johns Hopkins Hospital", slug: "johns-hopkins-hospital",
  time_zone: "Eastern Time (US & Canada)", locale: "en"
)

ucla_admin = User.create(
  email: "ucla@example.com", first_name: "Admin", last_name: "Ucla",
  current_clinic: ucla, password: "password", password_confirmation: "password"
)
johns_admin = User.create(
  email: "johns@example.com", first_name: "Admin", last_name: "Johns",
  current_clinic: johns, password: "password", password_confirmation: "password"
)

ucla_physician = User.create(
  email: "ucla_physician@example.com", first_name: "Doctor", last_name: "Dread",
  current_clinic: ucla, password: "password", password_confirmation: "password"
)
johns_physician = User.create(
  email: "johns_physician@example.com", first_name: "Doctor", last_name: "Doom",
  current_clinic: johns, password: "password", password_confirmation: "password"
)

physician_profile = Profile.create(
  title: "Physician",
  identifier: "123456789",
  approved: true,
  specializations: [{name: "Proctology", period: "2020-10-20..2065-06-17"}],
  additional_expertise: [{name: "Sick leave certifications", period: "2020-10-20..2065-06-17"}]
)
dentist_profile = Profile.create(
  title: "Dentist",
  identifier: "987654321",
  approved: true,
  specializations: [{name: "Orthodontist", period: "2020-10-20..2065-06-17"}],
  additional_expertise: []
)

Membership.create(
  [
    {user: ucla_admin, clinic: ucla, role_ids: [Role.admin]},
    {user: ucla_physician, clinic: ucla, role_ids: [Role.physician], current_profile: physician_profile},
    {user: johns_admin, clinic: johns, role_ids: [Role.admin]},
    {user: johns_physician, clinic: johns, role_ids: [Role.physician], current_profile: dentist_profile}
  ]
)
