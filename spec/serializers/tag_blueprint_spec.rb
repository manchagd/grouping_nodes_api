# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TagBlueprint do
  let(:tag) { create(:tag) }
  subject { TagBlueprint.render_as_hash(tag) }

  it 'serializes the tag with id and name' do
    is_expected.to match({
      id: tag.id,
      name: tag.name
    })
  end
end
