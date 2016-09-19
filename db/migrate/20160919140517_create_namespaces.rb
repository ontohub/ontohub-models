# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :namespaces do
      primary_key :id
      foreign_key :organizational_unit_id, :organizational_units, index: :unique
      DateTime :created_at
      DateTime :updated_at
    end

    alter_table :repositories do
      add_foreign_key :namespace_id, :namespaces, null: false
      add_index :namespace_id
      add_index %i(namespace_id slug), unique: true
    end
  end
end
