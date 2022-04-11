require "rails_helper"

RSpec.describe DecorateProfessionalJob, type: :job do
  let(:model) { create(:profile) }
  let(:payload) do
    OpenStruct.new(
      title: "Physician",
      identifier: model.identifier,
      approved: false,
      specializations: [{name: "Proctology"}]
    )
  end

  before do
    allow(Medix::Registry).to receive(:find).with(model.identifier).and_return(payload)
  end

  it "fetches data" do # rubocop:disable RSpec/MultipleExpectations
    described_class.perform_now(model)
    expect(model.title).to eq(payload.title)
    expect(model.approved).to be_falsey
  end
end
