# frozen_string_literal: true

class NodeBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :plate, :status, :category_id

  view :extended do
    association :category, blueprint: CategoryBlueprint, view: :basic
    fields :description, :number, :reference_code, :relative_age, :size, :time_slot, :created_at
  end
end
