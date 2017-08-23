# frozen_string_literal: true

require 'sequel/plugins/active_model'
module Sequel
  module Plugins
    # The ActiveModelSerializer plugin makes Sequel::Model objects
    # pass the ActiveModel::Serializer::Lint tests, which should
    # mean full ActiveModelSerializer compliance.
    # This plugin needs active_model to be plugged in as well.
    # Usage:
    #
    #   # Make all subclasses active_model_serializer compliant
    #   (called before loading subclasses)
    #   Sequel::Model.plugin :active_model
    #   Sequel::Model.plugin :active_model_serializer
    #
    #   # Make the Album class active_model_serializer compliant
    #   Album.plugin :active_model
    #   Album.plugin :active_model_serializer
    module ActiveModelSerializer
      # Instance methods of each model
      module InstanceMethods
        def serializable_hash
          as_json
        end

        def read_attribute_for_serialization(attribute)
          send(attribute)
        end

        def cache_key
          "#{self.class.to_s.downcase.pluralize}/"\
            "#{id}-#{updated_at&.strftime('%Y%m%d%H%M%S%6N')}"
        end
      end
    end
  end
end
