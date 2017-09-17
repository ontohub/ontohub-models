# frozen_string_literal: true

FactoryGirl.define do
  factory :file_range do
    path { generate(:filepath) }
    start_line { rand(10) }
    start_column { rand(80) }
    end_line { start_line + rand(10) }
    end_column do
      if start_line == end_line
        start_column + 1 + rand(80 - start_column)
      else
        rand(80)
      end
    end
  end
end
