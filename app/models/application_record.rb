# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def normalize_name
    return unless respond_to?(:name)

    self.name = name.squeeze(" ").strip.gsub(/\b.+?\b/, &:capitalize) if name.present?
  end
end
