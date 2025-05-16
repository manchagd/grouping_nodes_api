# frozen_string_literal: true

class TimeSlotEnum < EnumerateIt::Base
  associate_values(
    morning: 0,
    afternoon: 1,
    night: 2
  )
end
