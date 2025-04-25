# frozen_string_literal: true

class TimeStampController < ApplicationController
  def current
    render json: { current_time: Time.current.strftime("%d, %b %Y; %H:%M") }
  end
end
