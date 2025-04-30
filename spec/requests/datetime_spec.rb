# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Datetime", type: :request do
  describe "GET /datetime" do
    let(:parsed_response) { JSON.parse(response.body) }

    before { get "/datetime" }

    it 'returns a successful response' do
      expect(response).to have_http_status(:ok)
    end

    it "returns the correct structure" do
      expect(parsed_response).to have_key("data")
      expect(parsed_response["data"]).to include("type" => "date_and_time")
      expect(parsed_response["data"]).to have_key("attributes")
      expect(parsed_response["data"]["attributes"]).to have_key("value")
    end

    it "returns the date and time in the expected format" do
      value = parsed_response["data"]["attributes"]["value"]
      expect(value).to match(/\d{2}, \w{3} \d{4}; \d{2}:\d{2}/)
    end
  end
end
