require "hpr"

module Medix
  Professional = Struct.new(
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
    end
        
    def find
      Professional.new(
        service.name,
        service.hpr_number,
        service.birth_date,
        service.deceased_date,
        title,
        professional_data.approved?,
        specializations,
        additional_expertise
      )
    end

    def title
      @title ||= data.at_css("h3").text.strip
    end
    
    def professional_data
      @professional_data ||= Hpr::Professional.new(data)
    end
    
    def specializations
      @specializations ||= professional_data.specials.map(&:name)
    end
    
    def additional_expertise
      @additional_expertise ||= professional_data.additional_expertise.map(&:name)
    end
  end
end
