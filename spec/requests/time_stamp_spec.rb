# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "TimeStamp", type: :request do
  describe "GET /time_stamp" do
    it "Returns the current time" do
      get "/time_stamp"
      expect(response).to have_http_status(:success)
  
      json = JSON.parse(response.body)
      expect(json).to have_key("current_time")
    end

    it "Date and time are in accurate format" do
      get "/time_stamp"
      expect(response).to have_http_status(:success)
  
      json = JSON.parse(response.body)
      expect(json["current_time"]).to match(/\d{2}, \w{3} \d{4}; \d{2}:\d{2}/)
    end
  end
end