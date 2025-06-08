# frozen_string_literal: true

class CategoryBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :parent_id

  view :basic do
    exclude :parent_id
  end
  
  view :extended do
    association :parent, blueprint: CategoryBlueprint, view: :basic
    exclude :parent_id
  end
end
