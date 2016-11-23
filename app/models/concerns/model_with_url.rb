# frozen_string_literal: true

# This module adds a +url+ method to the model.
module ModelWithURL
  extend ActiveSupport::Concern

  def url(prefix)
    "#{prefix.sub(%r{/$}, '')}#{url_path}"
  end

  def validate
    validates_presence :url_path
    validates_format %r{\A/}, :url_path
    super
  end
end
