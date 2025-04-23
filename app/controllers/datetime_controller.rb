class DatetimeController < ApplicationController
  def current
    render json: { datetime: Time.current.strftime("%d, %b %Y; %H:%M") }
  end
end
