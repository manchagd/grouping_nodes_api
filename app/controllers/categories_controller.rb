# frozen_string_literal: true

class CategoriesController < ApplicationController
  def index
    @categories = Category.all
    render json: CategoryBlueprint.render(@categories)
  end

  def show
    render json: CategoryBlueprint.render(category, view: :extended)
  rescue ActiveRecord::RecordNotFound => e
    api_error(e.message, :not_found)
  end

  def create
    contract_result = contract_validation

    if contract_result.success?
      category = Category.new(contract_result.to_h)

      if category.save
        render json: CategoryBlueprint.render(category), status: :created
      else
        render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
      end
    else
      api_error(contract_errors(contract_result.errors.to_h), :unprocessable_entity)
    end
  rescue ActionController::ParameterMissing => e
    api_error(e.message, :bad_request)
  rescue ActiveRecord::InvalidForeignKey => e
    api_error(e.message, :unprocessable_entity)
  end

  def update
    contract_result = contract_validation

    if contract_result.success?
      if category.update(contract_result.to_h)
        render json: CategoryBlueprint.render(category), status: :ok
      else
        render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
      end
    else
      api_error(contract_errors(contract_result.errors.to_h), :unprocessable_entity)
    end
  rescue ActionController::ParameterMissing => e
    api_error(e.message, :bad_request)
  rescue ActiveRecord::InvalidForeignKey => e
    api_error(e.message, :unprocessable_entity)
  end

  
  def destroy
    category.destroy
    head :no_content
  rescue ActiveRecord::RecordNotFound => e
    api_error(e.message, :not_found)
  end

  private

  def contract_validation
    contract = CategoryContract.new

    contract.call(params.require(:category).permit!.to_h)
  end

  def category
    @category ||= Category.find(params[:id])
  end
end