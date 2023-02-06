require "bundler/setup"
require "combustion"
Bundler.require(:default)
require "minitest/autorun"
require "minitest/pride"
require "readline"

Combustion.path = "test/internal"
Combustion.initialize! :active_record

Archer.user = "test"
