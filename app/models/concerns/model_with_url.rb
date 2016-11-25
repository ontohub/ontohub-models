# frozen_string_literal: true

# This module adds a +url+ method to the model.
module ModelWithURL
  extend ActiveSupport::Concern

  attr_accessor :url_path_method

  def url(prefix)
    "#{prefix.sub(%r{/$}, '')}#{url_path}"
  end

  def before_validation
    if url_path_method.respond_to?(:call)
      self.url_path = url_path_method.call(self)
    end
    super
  end

  def validate
    validates_presence :url_path
    validates_format %r{\A/}, :url_path
    super
  end
end
