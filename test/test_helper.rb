require "bundler/setup"
Bundler.require(:default)
require "minitest/autorun"
require "minitest/pride"
require "active_record"
require "irb"
require "readline"

ActiveRecord::Base.logger = ActiveSupport::Logger.new(nil)
ActiveRecord::Migration.verbose = false

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

ActiveRecord::Migration.create_table :archer_history do |t|
  t.string :user
  t.text :commands
  t.datetime :updated_at
end

Archer.user = "test"
