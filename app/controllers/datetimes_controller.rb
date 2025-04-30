# frozen_string_literal: true

class DatetimesController < ApplicationController
  def show
    render json: {
      datetime: Time.current.strftime("%d, %b %Y; %H:%M")
    }
  end
end
