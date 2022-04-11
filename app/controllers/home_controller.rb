class HomeController < ApplicationController
  def index
    @professionals = if params[:query].present?
      Profile.where("full_name ILIKE ?", "%#{params[:query]}%")
    else
      Profile.all
    end
  end
end
