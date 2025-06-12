# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Nodes", type: :request do
  describe "GET /nodes" do
    before { create_list(:node, 5) }

    it "returns a successful response" do
      get '/nodes'
      expect(response).to have_http_status(:ok)
    end

    it "returns all nodes" do
      get '/nodes'
      expect(JSON.parse(response.body).length).to eq(5)
    end
  end

  describe "GET /nodes/:id" do
    let(:node) { create(:node) }

    context "when the node exists" do
      it "returns a successful response" do
        get "/nodes/#{node.id}"
        expect(response).to have_http_status(:ok)
      end

      it "returns the node" do
        get "/nodes/#{node.id}"
        expect(JSON.parse(response.body)["id"]).to eq(node.id)
      end
    end

    context "when the node does not exist" do
      it "returns status 404" do
        get "/nodes/999999"
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /nodes" do
    context "with valid parameters" do
      let(:category) { create(:category) }
      let(:valid_attributes) { {
        node: {
          name: "NewNode",
          number: 4,
          seal: "ABC",
          serie: "123",
          size: 30,
          status: "active",
          category_id: category.id,
          code_version: 1
        }
      } }

      it "creates a new node" do
        post "/nodes", params: valid_attributes
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { {
        node: {
          name: "",
          description: "",
          number: "",
          seal: "",
          serie: "",
          size: "",
          status: "",
          category_id: "",
          code_version: "",
          code_url: ""
        }
      } }

      it "returns unprocessable_entity" do
        post "/nodes", params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with missing parameters" do
      it "returns bad_request" do
        post "/nodes", params: {}
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe "PATCH /nodes/:id" do
    let(:node) { create(:node) }

    context "with valid parameters" do
      it "updates the node" do
        patch "/nodes/#{node.id}", params: { node: { description: "NewDescription" } }
        expect(JSON.parse(response.body)["description"]).to eq("NewDescription")
      end
    end

    context "with invalid parameters" do
      it "returns unprocessable_entity" do
        patch "/nodes/#{node.id}", params: { node: { seal: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /nodes/:id" do
    let(:node) { create(:node) }
    let!(:id) { node.id }

    it "deletes the node" do
      expect {
        delete "/nodes/#{id}"
      }.to change(Node, :count).by(-1)
    end

    it "returns the http status code" do
      delete "/nodes/#{id}"

      expect(response).to have_http_status(:no_content)
    end
  end
end
