class HomeController < ApplicationController
  before_action :turbo_frame_request_variant

  def index
    @profiles = if params[:query].present?
      Profile.where("full_name ILIKE ?", "%#{params[:query]}%")
    else
      Profile.none
    end
  end

  private

  def turbo_frame_request_variant
    request.variant = :turbo_frame if turbo_frame_request?
  end
end
