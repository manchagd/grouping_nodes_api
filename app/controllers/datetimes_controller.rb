# frozen_string_literal: true

class DatetimesController < ApplicationController
  def show
    render json: {
      data: {
        type: "date_and_time",
        attributes: {
          value: Time.current.strftime("%d, %b %Y; %H:%M")
        }
      }
    }
  end
end
