# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :repositories do
      primary_key :id
      String :name
      String :slug
      Text :description
      DateTime :created_at
      DateTime :updated_at
      index :slug
    end
  end
end
