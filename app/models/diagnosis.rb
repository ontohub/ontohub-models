# frozen_string_literal: true

# The Diagnosis model is the base class for Error, Warning, Hint and Debug.
class Diagnosis < Sequel::Model
  many_to_one :file_version
  many_to_one :file_range
end
