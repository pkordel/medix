class ApplicationController < ActionController::Base
  before_action :set_current_user
  protect_from_forgery with: :exception

  def set_current_user
    if current_user
      Current.user = current_user
    end
  end
end
