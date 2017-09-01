# frozen_string_literal: true

Sequel.migration do
  up do
    create_enum :organizational_unit_kind_type,
      %w(User Organization)

    create_table :organizational_units do
      primary_key :id
      # Kind of record - for class table inheritance
      column :kind, :organizational_unit_kind_type, null: false

      column :slug, String, null: false, unique: true

      column :display_name, String, null: true

      column :created_at, DateTime, null: false # This is set by a trigger
      column :updated_at, DateTime, null: false # This is set by a trigger
    end

    # User is an OrganizationalUnit
    create_enum :global_role,
      %w(admin user)

    create_table :users do
      primary_key :id
      foreign_key [:id], :organizational_units, null: false, unique: true

      column :secret, String, null: true

      # Devise database authenticatable
      column :email, String, null: false, unique: true
      column :encrypted_password, String, null: false

      # Devise confirmable
      column :confirmation_token, String, null: true
      column :confirmed_at, DateTime, null: true
      column :confirmation_sent_at, DateTime, null: true
      column :unconfirmed_email, String, null: true

      # Devise recoverable
      column :reset_password_token, String, null: true
      column :reset_password_sent_at, DateTime, null: true

      # Devise lockable
      column :failed_attempts, Integer, null: true, default: 0
      column :unlock_token, String, null: true
      column :locked_at, DateTime, null: true

      # Devise trackable
      column :sign_in_count, Integer, null: true, default: 0
      column :current_sign_in_at, DateTime, null: true
      column :last_sign_in_at, DateTime, null: true
      # Devise requires these columns to be set, but we don't want to store the
      # IP addresses in the database. We define empty getters/setters in the
      # model for these attributes:
      # column :current_sign_in_ip, String
      # column :last_sign_in_ip, String

      column :role, :global_role, null: false, default: 'user'
    end

    create_table :public_keys do
      primary_key :id
      foreign_key :user_id, :users, null: false, index: true

      column :name, String, null: false
      column :key, String, null: false

      column :created_at, DateTime, null: false # This is set by a trigger
      column :updated_at, DateTime, null: false # This is set by a trigger

      index [:user_id, :name], null: false, unique: true
    end

    # Organization is a OrganizationalUnit
    create_table :organizations do
      primary_key :id
      foreign_key [:id], :organizational_units, null: false, unique: true
      column :description, String, null: false
    end

    create_enum :organization_role,
      %w(admin write read)

    create_table :organization_memberships do
      primary_key [:organization_id, :member_id]
      foreign_key :organization_id, :organizations, null: false, index: true
      foreign_key :member_id, :users, null: false, index: true
      column :role, :organization_role, null: false, default: 'read'
    end

    create_enum :repository_content_type,
      %w(ontology model specification mathematical)

    create_table :repositories do
      primary_key :id
      column :slug, String, null: false, unique: true
      foreign_key :owner_id, :organizational_units, null: false, index: true

      column :name, String, null: false
      column :description, :text, null: true
      column :public_access, TrueClass, null: false
      column :content_type, :repository_content_type, null: false

      column :created_at, DateTime, null: false # This is set by a trigger
      column :updated_at, DateTime, null: false # This is set by a trigger
    end

    create_enum :repository_role,
      %w(admin write read)

    create_table :repository_memberships do
      primary_key [:repository_id, :member_id]
      foreign_key :repository_id, :repositories, null: false, index: true
      foreign_key :member_id, :users, null: false, index: true
      column :role, :repository_role, null: false, default: 'read'
    end

    create_enum :loc_id_base_kind_type,
      %w(FileVersion)

    create_table :loc_id_bases do
      primary_key :id
      # Kind of record - for class table inheritance
      column :kind, :loc_id_base_kind_type, null: false

      column :loc_id, String, null: false, unique: true

      column :created_at, DateTime, null: false # This is set by a trigger
      column :updated_at, DateTime, null: false # This is set by a trigger
    end

    # FileVersion is a LocIdBase
    create_table :file_versions do
      primary_key :id

      foreign_key :repository_id, :repositories, null: false, index: true

      column :commit_sha, String, null: false
      column :path, String, null: false

      column :created_at, DateTime, null: false # This is set by a trigger
      column :updated_at, DateTime, null: false # This is set by a trigger

      index [:repository_id, :commit_sha, :path], null: false, unique: true
    end

    # Setup created_at and updated_at triggers to automatically set these column
    # values.
    # See https://github.com/jeremyevans/sequel_postgresql_triggers
    extension :pg_triggers

    tables.select { |table| self[table].columns.include?(:created_at) }.
      each do |table|
      pgt_created_at(table,
                     :created_at,
                     function_name: :"#{table}_set_created_at",
                     trigger_name: :set_created_at)
    end

    tables.select { |table| self[table].columns.include?(:updated_at) }.
      each do |table|
      pgt_updated_at(table,
                     :updated_at,
                     function_name: :"#{table}_set_updated_at",
                     trigger_name: :set_updated_at)
    end
  end
end
