# frozen_string_literal: true

class FileVersion < Sequel::Model
  plugin :timestamps

  many_to_one :commit
end