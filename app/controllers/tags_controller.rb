# frozen_string_literal: true

class TagsController < ApplicationController
  def index
    @tags = Tag.all
    render json: TagBlueprint.render(@tags)
  end

  def show
    render json: TagBlueprint.render(tag)
  rescue ActiveRecord::RecordNotFound => e
    api_error(e.message, :not_found)
  end

  def create
    new_tag = Tag.new(tag_params)
    if new_tag.save
      render json: TagBlueprint.render(new_tag), status: :created
    else
      render json: { errors: new_tag.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActionController::ParameterMissing => e
    api_error(e.message, :bad_request)
  end

  def update
    if tag.update(tag_params)
      render json: TagBlueprint.render(tag)
    else
      render json: { errors: tag.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActionController::ParameterMissing => e
    api_error(e.message, :bad_request)
  end

  def destroy
    tag.destroy
    head :no_content
  rescue ActiveRecord::RecordNotFound => e
    api_error(e.message, :not_found)
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end

  def tag
    @tag ||= Tag.find(params[:id])
  end
end
