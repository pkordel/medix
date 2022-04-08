class DecorateProfessional < ActiveJob::Base
  queue_as :default

  def perform(professional_id)
    # professional = Professional.find_by(identifier: professional_id)
    data = Medix::Registry.find(professional_id)
    # professional.decorate(data)
  end
end