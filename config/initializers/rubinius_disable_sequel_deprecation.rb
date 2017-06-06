# frozen_string_literal: true

# rubocop:disable Style/Documentation

# Sequel uses Module#deprecate_constant but Rubinius doesn't have
# Module#deprecate_constant.
#
# Remove this file as soon as a Rubinius version has been released with
# https://github.com/rubinius/rubinius/issues/3606
# fixed.
# :nocov:
if RUBY_ENGINE == 'rbx'
  module Sequel
    def self.deprecate_constant(*_args); end

    class Error < ::StandardError
      def self.deprecate_constant(*_args); end
    end

    class DatabaseError < Error
      def self.deprecate_constant(*_args); end
    end

    class ConstraintViolation < DatabaseError
      def self.deprecate_constant(*_args); end
    end

    class Migrator
      def self.deprecate_constant(*_args); end
    end

    class Model
      def self.deprecate_constant(*_args); end
    end

    class ASTTransformer
      def self.deprecate_constant(*_args); end
    end

    class ConnectionPool
      def self.deprecate_constant(*_args); end
    end

    class Database
      def self.deprecate_constant(*_args); end
    end

    class Dataset
      def self.deprecate_constant(*_args); end

      module PreparedStatementMethods
        def self.deprecate_constant(*_args); end
      end
    end

    class Migration
      def self.deprecate_constant(*_args); end
    end

    class SimpleMigration
      def self.deprecate_constant(*_args); end
    end

    class AdapterNotFound < Error
      def self.deprecate_constant(*_args); end
    end

    class BasicObject < ::BasicObject
      def self.deprecate_constant(*_args); end
    end

    class BeforeHookFailed < Error
      def self.deprecate_constant(*_args); end
    end

    class CheckConstraintViolation < ConstraintViolation
      def self.deprecate_constant(*_args); end
    end

    class DatabaseConnectionError < DatabaseError
      def self.deprecate_constant(*_args); end
    end

    class DatabaseDisconnectError < DatabaseError
      def self.deprecate_constant(*_args); end
    end

    class ForeignKeyConstraintViolation < ConstraintViolation
      def self.deprecate_constant(*_args); end
    end

    class HookFailed < Error
      def self.deprecate_constant(*_args); end
    end

    class IntegerMigrator < Migrator
      def self.deprecate_constant(*_args); end
    end

    class InvalidOperation < Error
      def self.deprecate_constant(*_args); end
    end

    class InvalidValue < Error
      def self.deprecate_constant(*_args); end
    end

    class LiteralString < ::String
      def self.deprecate_constant(*_args); end
    end

    class MassAssignmentRestriction < Error
      def self.deprecate_constant(*_args); end
    end

    class MigrationAlterTableReverser < BasicObject
      def self.deprecate_constant(*_args); end
    end

    class MigrationDSL < BasicObject
      def self.deprecate_constant(*_args); end
    end

    class MigrationReverser < BasicObject
      def self.deprecate_constant(*_args); end
    end

    class NoExistingObject < Error
      def self.deprecate_constant(*_args); end
    end

    class NoMatchingRow < Error
      def self.deprecate_constant(*_args); end
    end

    class NotNullConstraintViolation < ConstraintViolation
      def self.deprecate_constant(*_args); end
    end

    class PoolTimeout < Error
      def self.deprecate_constant(*_args); end
    end

    class Qualifier < ASTTransformer
      def self.deprecate_constant(*_args); end
    end

    class Rollback < Error
      def self.deprecate_constant(*_args); end
    end

    class SQLTime < ::Time
      def self.deprecate_constant(*_args); end
    end

    class SerializationFailure < DatabaseError
      def self.deprecate_constant(*_args); end
    end

    class ThreadedConnectionPool < ConnectionPool
      def self.deprecate_constant(*_args); end
    end

    class TimestampMigrator < Migrator
      def self.deprecate_constant(*_args); end
    end

    class UnbindDuplicate < Error
      def self.deprecate_constant(*_args); end
    end

    class Unbinder < ASTTransformer
      def self.deprecate_constant(*_args); end
    end

    class UndefinedAssociation < Error
      def self.deprecate_constant(*_args); end
    end

    class UniqueConstraintViolation < ConstraintViolation
      def self.deprecate_constant(*_args); end
    end

    class ValidationFailed < Error
      def self.deprecate_constant(*_args); end
    end

    module DeprecatedIdentifierMangling
      def self.deprecate_constant(*_args); end
    end

    module Deprecation
      def self.deprecate_constant(*_args); end
    end

    module Inflections
      def self.deprecate_constant(*_args); end
    end

    module Plugins
      def self.deprecate_constant(*_args); end
    end

    module Postgres
      def self.deprecate_constant(*_args); end

      module DatabaseMethods
        def self.deprecate_constant(*_args); end
      end

      module DatasetMethods
        def self.deprecate_constant(*_args); end
      end
    end

    module Schema
      def self.deprecate_constant(*_args); end
    end

    module SQL
      def self.deprecate_constant(*_args); end
    end

    module Timezones
      def self.deprecate_constant(*_args); end
    end

    module UnmodifiedIdentifiers
      def self.deprecate_constant(*_args); end
    end
  end
end
# :nocov:
