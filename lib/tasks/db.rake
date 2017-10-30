# frozen_string_literal: true

namespace :db do
  desc 'Recreate the database (drop, create, migrate)'
  task :recreate do
    begin
      Rake::Task['db:drop'].invoke
      # rubocop:disable Lint/HandleExceptions
      # If the database does not yet exist, we don't want to fail.
      # We cannot check the error message because of different locales.
    rescue Sequel::DatabaseConnectionError
      # rubocop:enable Lint/HandleExceptions
    end
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
  end
end
