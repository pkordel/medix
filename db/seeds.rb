ucla = Clinic.create(
  name: "UCLA Medical Center", slug: "ucla-medical-center",
  time_zone: "Pacific Time (US & Canada)", locale: "en"
)
johns = Clinic.create(
  name: "Johns Hopkins Hospital", slug: "johns-hopkins-hospital",
  time_zone: "Eastern Time (US & Canada)", locale: "en"
)
mayo = Clinic.create(
  name: "Mayo Clinic", slug: "mayo-clinic",
  time_zone: "Eastern Time (US & Canada)", locale: "en"
)

ucla_admin = User.create(
  email: "ucla@example.com", first_name: "Admin", last_name: "Ucla",
  current_clinic: ucla, password: "password", password_confirmation: "password"
)
johns_admin = User.create(
  email: "johns@example.com", first_name: "Admin", last_name: "Johns",
  current_clinic: mayo, password: "password", password_confirmation: "password"
)
mayo_admin = User.create(
  email: "mayo@example.com", first_name: "Admin", last_name: "Mayo",
  current_clinic: mayo, password: "password", password_confirmation: "password"
)

Membership.create(
  [
    {user: ucla_admin, clinic: ucla, role_ids: ["admin"]},
    {user: johns_admin, clinic: johns, role_ids: ["admin"]},
    {user: mayo_admin, clinic: mayo, role_ids: ["admin"]}
  ]
)
