# frozen_string_literal: true

Devise.setup do |config|
  # ==> Configuration for :database_authenticatable
  # For bcrypt, this is the cost for hashing the password and defaults to 11. If
  # using other encryptors, it sets how many times you want the password
  # re-encrypted.
  #
  # Limiting the stretches to just one in testing will increase the performance
  # of your test suite dramatically. However, it is STRONGLY RECOMMENDED to not
  # use a value less than 10 in other environments.
  config.stretches = Rails.env.test? ? 1 : 13
end
