# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Categories", type: :request do
  describe "GET /categories" do
    before { create_list(:category, 15) }

    it "returns a successful response" do
      get '/categories'
      expect(response).to have_http_status(:ok)
    end

    it "returns all categories" do
      get '/categories'
      expect(JSON.parse(response.body).length).to eq(15)
    end
  end

  describe "GET /categories/:id" do
    let(:category) { create(:category) }

    context "when the category exists" do
      it "returns a successful response" do
        get "/categories/#{category.id}"
        expect(response).to have_http_status(:ok)
      end

      it "returns the category" do
        get "/categories/#{category.id}"
        expect(JSON.parse(response.body)["id"]).to eq(category.id)
      end
    end

    context "when the category does not exist" do
      it "returns status 404" do
        get "/categories/999999"
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /categories" do
    context "with valid parameters" do
      let!(:parent) { create(:category, name: "Parent Category") }
      let(:valid_attributes) { { category: { name: "New Category", parent_id: parent.id } } }

      before { post "/categories", params: valid_attributes, as: :json }

      it "creates a new category" do
        expect(response).to have_http_status(:created)
      end

      it "sets the correct name" do
        expect(JSON.parse(response.body)["name"]).to eq("New Category")
      end

      it "sets a valid parent" do
        expect(JSON.parse(response.body)["parent_id"]).to eq(parent.id)
      end
    end

    context "with invalid parameters" do
      it "returns unprocessable_entity if name is invalid" do
        post "/categories", params: { category: { name: 123 } }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns unprocessable_entity if parent_id is invalid" do
        post "/categories", params: { category: { name: "ValidName", parent_id: -999 } }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with missing parameters" do
      it "returns bad_request" do
        post "/categories", params: {}
        expect(response).to have_http_status(:bad_request)
      end
    end

    context "with parent_id missing in the data base" do
      it "returns unprocessable_entity" do
        post "/categories", params: { category: { name: "ValidName", parent_id: 9999 } }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /categories/:id" do
    let(:category) { create(:category) }

    context "with valid parameters" do
      it "updates the category" do
        patch "/categories/#{category.id}", params: { category: { name: "Updated" } }, as: :json
        expect(JSON.parse(response.body)["name"]).to eq("Updated")
      end
    end

    context "with invalid parameters" do
      it "returns unprocessable_entity when parameters fail model validations" do
        patch "/categories/#{category.id}", params: { category: { name: "" } }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns unprocessable_entity when contract validation fails due to type mismatch" do
        patch "/categories/#{category.id}", params: { category: { name: 123 } }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with missing parameters" do
      it "returns bad_request" do
        patch "/categories/#{category.id}", params: {}
        expect(response).to have_http_status(:bad_request)
      end
    end

    context "with parent_id missing in the data base" do
      it "returns unprocessable_entity" do
        patch "/categories/#{category.id}", params: { category: { name: "UpdatedName", parent_id: 99999 } }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /categories/:id" do
    let(:category) { create(:category) }
    let!(:id) { category.id }

    context "when id exists in the database" do
      it "deletes the category" do
        expect {
          delete "/categories/#{id}"
        }.to change(Category, :count).by(-1)
      end

      it "returns the http status code" do
        delete "/categories/#{id}"

        expect(response).to have_http_status(:no_content)
      end
    end

    context "when id does not exists" do
      it "returns not found" do
        delete "/categories/10000"

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
