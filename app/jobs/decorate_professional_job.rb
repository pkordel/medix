class DecorateProfessionalJob < ApplicationJob
  queue_as :default

  def perform(model)
    # TODO: What should this object be called?
    # TODO: decorate method encapsulates mutations of this object.
    # data = Medix::Registry.find(model.identifier)
    # model.decorate(data)
    Medix::Registry.find(model.identifier)
  end
end
