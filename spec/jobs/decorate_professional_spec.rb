require "rails_helper"

RSpec.describe DecorateProfessional, type: :job do
  let(:model) { OpenStruct.new(name: "John Doe", identifier: 1234567) }

  it "fetches data" do
    allow(Medix::Registry).to receive(:find).with(1234567).and_return(model)
    expect(described_class.perform_now(model)).to eq model
  end
end
