class TagsController < ApplicationController
  before_action :set_tag, only: %i[show update destroy]

  def index
    @tags = Tag.all
  end

  def show
  end

  def create
    tag = Tag.create(tag_params)

    redirect_to tags_path
  end

  def update
    @tag.update(tag_params)

    redirect_to tag_path(@tag)
  end

  def destroy
    @tag.destroy

    redirect_to tags_path
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end

  def set_tag
    @tag = Tag.find(params[:id])
  end
end

  