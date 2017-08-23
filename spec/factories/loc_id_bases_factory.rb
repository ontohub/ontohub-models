# frozen_string_literal: true

FactoryGirl.define do
  factory :loc_id_base do
    url_path_method do
      ->(file_version) { "/loc_id_base/#{file_version.to_param}" }
    end
  end
end
