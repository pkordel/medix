require "hpr"

module Medix
  Payload = Struct.new(
    :name,
    :identifier,
    :birth_date,
    :deceased_date,
    :title,
    :approved?,
    :specializations,
    :qualifications
  )

  class Registry
    attr_reader :service, :data, :professional_data

    def self.find(hpr_number)
      new(hpr_number).find
    end

    def initialize(identifier)
      @service = Hpr.scraper(hpr_number: identifier)
      @data = service.approval_boxes.first
      @professional_data = Hpr::Professional.new(data)
    end

    def find
      Payload.new(
        service.name,
        service.hpr_number,
        service.birth_date,
        service.deceased_date,
        title,
        professional_data.approved?,
        professional_data.specials.map(&:name),
        professional_data.additional_expertise.map(&:name)
      )
    end

    def title
      @title ||= data.at_css("h3").text.strip
    end
  end
end
