# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Tags", type: :request do
  describe "GET /tags" do
    before { create_list(:tag, 10) }

    it "returns a successful response" do
      get '/tags'
      expect(response).to have_http_status(:ok)
    end

    it "returns all tags" do
      get '/tags'
      expect(JSON.parse(response.body).length).to eq(10)
    end
  end

  describe "GET /tags/:id" do
    let(:tag) { create(:tag) }
    let(:id) { tag.id }

    context "when the tag exists" do
      it "returns a successful response" do
        get "/tags/#{id}"
        expect(response).to have_http_status(:ok)
      end

      it "returns the tag" do
        get "/tags/#{id}"
        expect(JSON.parse(response.body)["id"]).to eq(id)
      end
    end

    context "when the tag does not exist" do
      it "returns status 404" do
        get "/tags/999999"
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /tags" do
    context "with valid parameters" do
      let(:valid_attributes) { { tag: { name: "New Tag" } } }

      it "creates a new tag" do
        post "/tags", params: valid_attributes
        expect(response).to have_http_status(:created)
      end

      it "sets the correct name" do
        post "/tags", params: valid_attributes
        expect(JSON.parse(response.body)["name"]).to eq("New Tag")
      end
    end

    context "with invalid parameters" do
      it "returns unprocessable_entity" do
        post "/tags", params: { tag: { name: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with missing parameters" do
      it "returns bad_request" do
        post "/tags", params: {}
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe "PATCH /tags/:id" do
    let(:tag) { create(:tag) }
    let(:id) { tag.id }

    context "with valid parameters" do
      it "updates the tag" do
        patch "/tags/#{id}", params: { tag: { name: "Updated" } }
        expect(JSON.parse(response.body)["name"]).to eq("Updated")
      end
    end

    context "with invalid parameters" do
      it "returns unprocessable_entity" do
        patch "/tags/#{id}", params: { tag: { name: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with missing parameters" do
      it "returns not found" do
        patch "/tags", params: {}
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE /tags/:id" do
    let(:tag) { create(:tag) }
    let!(:id) { tag.id }

    context "when id exists in the database" do
      it "deletes the tag" do
        expect {
          delete "/tags/#{id}"
        }.to change(Tag, :count).by(-1)
      end

      it "returns the http status code" do
        delete "/tags/#{id}"

        expect(response).to have_http_status(:no_content)
      end
    end

    context "when id does not exists" do
      it "returns not found" do
        delete "/nodes/10000"

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
