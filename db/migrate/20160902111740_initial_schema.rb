# frozen_string_literal: true

Sequel.migration do
  change do
    create_enum :organizational_unit_kind_type,
      %w(OrganizationalUnit User Organization)
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
      primary_key :id
      foreign_key [:id], :organizational_units, unique: true
      column :real_name, String

      column :email, String
      column :encrypted_password, String
      column :secret, String
    end

    create_table :organizations do
      primary_key :id
      foreign_key [:id], :organizational_units, unique: true
      column :real_name, String
      column :description, String
    end

    create_table :organizations_members do
      foreign_key :organization_id, :organizations, index: true
      foreign_key :member_id, :users, index: true
    end

    create_enum :repository_content_type, %w(ontology model specification)
    create_table :repositories do
      primary_key :id
      foreign_key :owner_id, :organizational_units,
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

    create_table :commits do
      primary_key :id
      foreign_key :repository_id, :repositories, index: true, null: false
      foreign_key :author_id, :users, index: true
      foreign_key :committer_id, :users, index: true
      foreign_key :pusher_id, :users, index: true, null: false

      column :author_name, String
      column :committer_name, String
      column :author_email, String
      column :committer_email, String
      column :authored_at, DateTime
      column :committed_at, DateTime
      column :shasum, String, index: true
      column :url_path, String, unique: true
      column :created_at, DateTime
      column :updated_at, DateTime
    end

    create_table :file_versions do
      primary_key :id
      foreign_key :commit_id, :commits, index: true, null: false

      column :path, String
      column :url_path, String, unique: true
      column :created_at, DateTime
      column :updated_at, DateTime
    end
  end
end
