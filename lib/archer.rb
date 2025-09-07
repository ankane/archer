# dependencies
require "active_support/core_ext/module/attribute_accessors"

# modules
require_relative "archer/adapter"
require_relative "archer/engine" if defined?(Rails)
require_relative "archer/irb"
require_relative "archer/version"

module Archer
  autoload :Coder, "archer/coder"
  autoload :History, "archer/history"

  mattr_accessor :limit
  self.limit = 200

  mattr_accessor :user
  self.user = ENV["USER"]

  mattr_accessor :save_session
  self.save_session = true

  # experimental
  mattr_accessor(:adapter) { Adapter.new }

  class << self
    def start
      if !history_object
        warn "[archer] Skipping history"
        return
      end

      commands = nil
      begin
        commands = adapter.load(user: user)
      rescue => e
        warn "[archer] #{e.message}"
      end

      if commands
        history_object.clear
        history_object.push(*commands)
      end

      IRB.conf[:AT_EXIT].push(proc { Archer.save if Archer.save_session })
    rescue
      # never prevent console from booting
      warn "[archer] Error loading history"
    end

    def save
      return false unless history_object

      commands = history_object.to_a.last(limit)
      adapter.save(commands, user: user)
    rescue
      warn "[archer] Unable to save history"
      false
    end

    def clear
      adapter.clear(user: user)
      history_object.clear if history_object
      true
    end

    private

    def history_object
      cls = IRB.CurrentContext&.io&.class
      cls && cls.const_defined?(:HISTORY) ? cls::HISTORY : nil
    end
  end
end
