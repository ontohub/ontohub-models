# frozen_string_literal: true

namespace :db do
  desc 'Recreate the database (drop, create, migrate)'
  task :recreate do
    begin
      Rake::Task['db:drop'].invoke
    rescue Sequel::DatabaseConnectionError => e
    end
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
  end
end
