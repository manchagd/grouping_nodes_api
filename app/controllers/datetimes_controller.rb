# frozen_string_literal: true

class DatetimesController < ApplicationController
  def show
    render json: { current_time: Time.current.strftime("%d, %b %Y; %H:%M") }
  end
end
