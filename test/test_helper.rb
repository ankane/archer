require "bundler/setup"
require "combustion"
Bundler.require(:default)
require "minitest/autorun"
require "minitest/pride"
require "rails/command"
require "rails/commands/console/console_command"

logger = ActiveSupport::Logger.new(ENV["VERBOSE"] ? STDOUT : nil)

Combustion.path = "test/internal"
Combustion.initialize! :active_record do
  config.active_record.logger = logger
end

Archer.user = "test"

IRB.setup(nil)
irb = IRB::Irb.new
IRB.conf[:MAIN_CONTEXT] = irb.context

# run console hooks
Rails::Console.new(Rails.application)
