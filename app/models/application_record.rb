# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def normalize_name(name)
    name.squeeze(" ").strip.split.map(&:capitalize).join(" ") if name.present?
  end
end
