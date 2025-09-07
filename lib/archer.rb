# dependencies
require "active_support/core_ext/module/attribute_accessors"

# modules
require_relative "archer/engine" if defined?(Rails)
require_relative "archer/irb"
require_relative "archer/storage"
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
  mattr_accessor(:storage) { Storage.new }

  class << self
    def start
      if !history
        warn "[archer] Skipping history"
        return
      end

      commands = nil
      begin
        commands = storage.load(user: user)
      rescue => e
        warn "[archer] #{e.message}"
      end

      if commands
        history.clear
        history.push(*commands)
      end

      IRB.conf[:AT_EXIT].push(proc { Archer.save if Archer.save_session })
    rescue
      # never prevent console from booting
      warn "[archer] Error loading history"
    end

    def save
      return false unless history

      commands = history.to_a.last(limit)
      storage.save(commands, user: user)
    rescue
      warn "[archer] Unable to save history"
      false
    end

    def clear
      storage.clear(user: user)
      history.clear if history
      true
    end

    private

    def history
      cls = IRB.CurrentContext&.io&.class
      cls && cls.const_defined?(:HISTORY) ? cls::HISTORY : nil
    end
  end
end
