class DecorateProfessionalJob < ApplicationJob
  queue_as :default

  def perform(profile)
    data = Medix::Registry.find(profile.identifier)
    profile.update(
      title: data.title,
      approved: data.approved?,
      specializations: data.specializations,
      additional_expertise: data.additional_expertise
    )
  end
end
