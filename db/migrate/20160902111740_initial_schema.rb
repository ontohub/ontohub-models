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

      column :slug, String, unique: true
      column :display_name, String, null: true

      column :created_at, DateTime
      column :updated_at, DateTime
    end

    # User is an OrganizationalUnit
    create_enum :global_role,
      %w(admin user)
    create_table :users do
      primary_key :id
      foreign_key [:id], :organizational_units, unique: true

      column :email, String, unique: true
      column :encrypted_password, String
      column :secret, String

      column :role, :global_role

      # Devise confirmable
      column :confirmation_token, String
      column :confirmed_at, DateTime
      column :confirmation_sent_at, DateTime
      column :unconfirmed_email, String

      # Devise recoverable
      column :reset_password_token, String
      column :reset_password_sent_at, DateTime
    end

    # Organization is a OrganizationalUnit
    create_table :organizations do
      primary_key :id
      foreign_key [:id], :organizational_units, unique: true
      column :description, String
    end

    create_enum :organization_role,
      %w(admin write read)
    create_table :organization_memberships do
      primary_key [:organization_id, :member_id]
      foreign_key :organization_id, :organizations, index: true
      foreign_key :member_id, :users, index: true
      column :role, :organization_role
    end

    create_enum :repository_content_type,
      %w(ontology model specification mathematical)
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

    create_enum :repository_role,
      %w(admin write read)
    create_table :repository_memberships do
      primary_key [:repository_id, :member_id]
      foreign_key :repository_id, :repositories, index: true
      foreign_key :member_id, :users, index: true
      column :role, :repository_role
    end

    create_enum :loc_id_base_kind_type,
      %w(FileVersion)
    create_table :loc_id_bases do
      primary_key :id
      # Kind of record - for class table inheritance
      column :kind, :loc_id_base_kind_type

      # The actual Loc/Id is saved in url_path to stay consistent throughout the
      # code.
      column :url_path, String, unique: true
      column :created_at, DateTime
      column :updated_at, DateTime
    end

    # FileVersion is a LocIdBase
    create_table :file_versions do
      primary_key :id
      foreign_key [:id], :loc_id_bases, unique: true

      foreign_key :repository_id, :repositories, index: true, null: false

      column :commit_sha, String, null: false
      column :path, String, null: false
      index [:repository_id, :commit_sha, :path], unique: true
    end
  end
end
