# frozen_string_literal: true

module ActiveSupport
  # Override the constantize method for the exception of "OMS". Otherwise the
  # factories won't work because the default constantized value is Oms.
  module Inflector
    original_definition_of_constantize = instance_method(:constantize)

    define_method(:constantize) do |camel_cased_word|
      if %w(oms ::oms).include?(camel_cased_word.downcase)
        ::OMS
      else
        original_definition_of_constantize.bind(self).call(camel_cased_word)
      end
    end
  end
end
