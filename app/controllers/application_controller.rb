# frozen_string_literal: true

class ApplicationController < ActionController::API
  wrap_parameters false

  private

  def api_error(messages, status_code)
    render json: { errors: [ messages ].flatten }, status: status_code
  end
end
