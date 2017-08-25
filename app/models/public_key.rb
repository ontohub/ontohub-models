# frozen_string_literal: true

# Class to hold a user's public key
class PublicKey < Sequel::Model
  many_to_one :user
end
