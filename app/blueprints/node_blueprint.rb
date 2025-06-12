# frozen_string_literal: true

class NodeBlueprint < Blueprinter::Base
  identifier :id

  association :category, blueprint: CategoryBlueprint, view: :basic
  fields :name, :plate, :status, :category_id, :description, :number, :reference_code, :relative_age, :size, :time_slot, :created_at
end
