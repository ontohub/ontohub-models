# frozen_string_literal: true

Sequel.migration do
  change do
    create_enum :repository_content_type, %w(ontology model specification)
    alter_table :repositories do
      add_column :private_access, TrueClass
      add_column :content_type, :repository_content_type
    end
  end
end
