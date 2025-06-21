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
    new_category = Category.new(category_params)
    if new_category.save
      render json: CategoryBlueprint.render(new_category), status: :created
    else
      api_error(new_category.errors.full_messages, :unprocessable_entity)
    end
  rescue ActionController::ParameterMissing => e
    api_error(e.message, :bad_request)
  end

  def update
    if category.update(category_params)
      render json: CategoryBlueprint.render(category, view: :extended)
    else
      api_error(category.errors.full_messages, :unprocessable_entity)
    end
  rescue ActionController::ParameterMissing => e
    api_error(e.message, :bad_request)
  end

  def destroy
    category.destroy
    head :no_content
  rescue ActiveRecord::RecordNotFound => e
    api_error(e.message, :not_found)
  end

  private

  def category_params
    params.require(:category).permit(:name, :parent_id)
  end

  def category
    @category ||= Category.find(params[:id])
  end
end
