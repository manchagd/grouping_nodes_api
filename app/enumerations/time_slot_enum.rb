class TimeSlotEnum < EnumerateIt::Base
  associate_values(
    :morning,
    :afternoon,
    :night
  )
end