# frozen_string_literal: true

class CategoriesController < ApplicationController
  def index
    @categories = Category.all
    render json: CategoryBlueprint.render(@categories)
  end

  def show
    render json: CategoryBlueprint.render(category, view: :extended)
  end

  def create
    new_category = Category.new(category_params)
    if new_category.save
      render json: CategoryBlueprint.render(new_category, view: :extended), status: :created
    else
      render json: { errors: new_category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if category.update(category_params)
      render json: CategoryBlueprint.render(category, view: :extended)
    else
      render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    category.destroy
    head :no_content
  end

  private

  def category_params
    params.require(:category).permit(:name, :parent_id)
  end

  def category
    @category ||= Category.find(params[:id])
  end
end
