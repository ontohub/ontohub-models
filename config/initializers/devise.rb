# frozen_string_literal: true

Devise.setup do |config|
  # ==> Configuration for :database_authenticatable
  # For bcrypt, this is the cost for hashing the password and defaults to 11. If
  # using other encryptors, it sets how many times you want the password
  # re-encrypted.
  #
  # Limiting the stretches to just one in testing will increase the performance
  # of your test suite dramatically. However, it is STRONGLY RECOMMENDED to not
  # use a value less than 13 in other environments.
  config.stretches = Rails.env.test? ? 1 : 13

  # ==> Configuration for :validatable
  # Range for password length.
  config.password_length = 10..128

  # Email regex used to validate email formats. It simply asserts that one (and
  # only one) @ exists in the given string. This is mainly to give user
  # feedback and not to assert the e-mail validity.
  config.email_regexp = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/
end
