# frozen_string_literal: true

# This adds a "messages" method to Sequel::Model::Errors that behaves like
# ActiveModelSerializers needs it.

module Sequel
  class Model
    # The errors class of the Sequel::Model needs to be expanded by a messages
    # method for ActiveModel::Serializer to work properly.
    class Errors
      # The #errors hash is already formed as we need the messages to be.
      def messages
        self
      end
    end
  end
end
