class CategoryBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :parent_id

  view :basic do
    fields :name
  end

  view :extended do
    association :parent, blueprint: CategoryBlueprint, view: :basic
  end
end