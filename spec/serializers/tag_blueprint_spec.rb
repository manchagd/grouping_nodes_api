# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TagBlueprint do
  let(:tag) { create(:tag) }

  it 'serializes the tag with id and name' do
    expect(tag['name']).to be_present
    expect(tag['id']).to be_present
  end
end
