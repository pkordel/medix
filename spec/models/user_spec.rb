require "rails_helper"

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(create(:user)).to be_valid
  end

  it "details_provided are true when details are provided" do
    expect(create(:user, first_name: "a", last_name: "b")).to be_details_provided
  end

  it "details_provided are false when details are not provided" do
    expect(create(:user, first_name: "a", last_name: nil)).not_to be_details_provided
  end
end
