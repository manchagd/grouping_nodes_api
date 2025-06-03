# frozen_string_literal: true

class NodeStatusEnum < EnumerateIt::Base
  associate_values(
    :active,
    :inactive,
    :deprecated
  )
end
