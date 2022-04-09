require "rails_helper"

RSpec.describe Profile, type: :model do
  describe "approved?" do
    it "returns true if approved is true" do
      profile = build(:profile, approved: true)
      expect(profile).to be_approved
    end

    it "returns false if approved is false" do
      profile = build(:profile, approved: false)
      expect(profile).not_to be_approved
    end
  end
end
