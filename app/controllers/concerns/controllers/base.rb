module Controllers::Base
  extend ActiveSupport::Concern

  included do
    include DeviseCurrentAttributes

    before_action { @updating = request.headers["X-Cable-Ready"] == "update" }

    skip_before_action :verify_authenticity_token, if: -> { controller_name == "sessions" && action_name == "create" }
  end
end
