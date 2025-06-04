# frozen_string_literal: true

class TagsController < ApplicationController
  before_action :set_tag, only: %i[show update destroy]

  def index
    @tags = Tag.all
    render json: TagBlueprint.render(@tags)
  end

  def show
    render json: TagBlueprint.render(@tag)
  end

  def create
    tag = Tag.new(tag_params)
    if tag.save
      render json: TagBlueprint.render(tag), status: :created
    else
      render json: { errors: tag.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @tag.update(tag_params)
      render json: TagBlueprint.render(@tag)
    else
      render json: { errors: @tag.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @tag.destroy
    head :no_content
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end

  def set_tag
    @tag = Tag.find(params[:id])
  end
end
