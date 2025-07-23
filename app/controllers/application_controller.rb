# frozen_string_literal: true

class ApplicationController < ActionController::API
  wrap_parameters false

  private
  def contract_errors(result_errors)
    result_errors.reduce([]) do |errors, (field_name, field_errors)|
      errors += field_errors.map { |error| "#{field_name}, #{error}" }
    end
  end

  def api_error(messages, status_code)
    render json: { errors: [ messages ].flatten }, status: status_code
  end
end
