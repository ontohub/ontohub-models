# frozen_string_literal: true

Sequel.migration do
  change do
    create_enum :organizational_unit_kind_type, %w(OrganizationalUnit User Team)
    create_table :organizational_units do
      primary_key :id
      # Kind of record - for class table inheritance
      column :kind, :organizational_unit_kind_type

      column :url_path, String, unique: true

      column :name, String
      column :slug, String, unique: true

      column :created_at, DateTime
      column :updated_at, DateTime
    end

    create_table :users do
      foreign_key :id, :organizational_units, unique: true
      column :real_name, String

      column :email, String
      column :encrypted_password, String
      column :secret, String
    end

    create_enum :repository_content_type, %w(ontology model specification)
    create_table :repositories do
      primary_key :id
      foreign_key :organizational_unit_id, :organizational_units,
                  index: true, null: false

      column :url_path, String, unique: true

      column :name, String
      column :slug, String, unique: true
      column :description, :text
      column :created_at, DateTime
      column :updated_at, DateTime
      column :public_access, TrueClass
      column :content_type, :repository_content_type
    end
  end
end
