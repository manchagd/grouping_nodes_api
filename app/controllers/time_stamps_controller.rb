# frozen_string_literal: true

class TimeStampsController < ApplicationController
  def show
    render json: { current_time: Time.current.strftime("%d, %b %Y; %H:%M") }
  end
end
