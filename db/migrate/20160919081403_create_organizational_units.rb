# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :organizational_units do
      primary_key :id
      # Kind of record - for class table inheritance
      String :kind

      String :name
      String :slug, index: :unique

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
