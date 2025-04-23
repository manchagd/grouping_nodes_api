class DatetimeController < ApplicationController
  def current
    render json: { datetime: Time.current.strftime("%d, %m %Y; %H:%M") }
  end
end
