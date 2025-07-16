class CategoryContract < Dry::Validation::Contract
  json do
    optional(:name).value(:string)
    optional(:parent_id).value(:integer)
  end
end