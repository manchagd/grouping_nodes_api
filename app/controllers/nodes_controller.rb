# frozen_string_literal: true

class NodesController < ApplicationController
  def index
    @nodes = Node.all
    render json: NodeBlueprint.render(@nodes)
  end

  def show
    render json: NodeBlueprint.render(node, view: :extended)
  end

  def create
    new_node = Node.new(node_params)
    if new_node.save
      render json: NodeBlueprint.render(new_node), status: :created
    else
      render json: { errors: new_node.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if node.update(node_params)
      render json: NodeBlueprint.render(node, view: :extended)
    else
      render json: { errors: node.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    node.destroy
    head :no_content
  end

  private

  def node_params
    params.require(:node).permit(:name, :description, :number, :seal, :serie, :size, :status, :category_id, :code_version, :code_url)
  end

  def node
    @node ||= Node.find(params[:id])
  end
end
