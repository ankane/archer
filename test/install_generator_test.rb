require_relative "test_helper"

require "rails/generators/test_case"
require "generators/archer/install_generator"

class InstallGeneratorTest < Rails::Generators::TestCase
  tests Archer::Generators::InstallGenerator
  destination File.expand_path("../tmp", __dir__)
  setup :prepare_destination

  def test_works
    run_generator
    assert_migration "db/migrate/create_archer_history.rb", /create_table/
  end
end
