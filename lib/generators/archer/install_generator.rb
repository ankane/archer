require "rails/generators/active_record"

module Archer
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include ActiveRecord::Generators::Migration
      source_root File.join(__dir__, "templates")

      def copy_migration
        migration_template "migration.rb", "db/migrate/create_archer_history.rb", migration_version: migration_version
      end

      def migration_version
        ActiveRecord::Migration.current_version
      end
    end
  end
end
