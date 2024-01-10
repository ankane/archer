# dependencies
require "active_support/core_ext/module/attribute_accessors"

# stdlib
require "json"

# modules
require_relative "archer/coder"
require_relative "archer/engine" if defined?(Rails)
require_relative "archer/irb"
require_relative "archer/version"

module Archer
  autoload :History, "archer/history"

  mattr_accessor :limit
  self.limit = 200

  mattr_accessor :user
  self.user = ENV["USER"]

  mattr_accessor :save_session
  self.save_session = true

  class << self
    def start
      if !history_object
        warn "[archer] Skipping history"
        return
      end

      history = nil
      begin
        quietly do
          history = Archer::History.find_by(user: user)
        end
      rescue ActiveRecord::StatementInvalid
        warn "[archer] Create table to enable history"
      end

      if history
        commands = history.commands
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

      quietly do
        history = Archer::History.where(user: user).first_or_initialize
        history.commands = history_object.to_a.last(limit)
        history.save!
      end
    rescue ActiveRecord::StatementInvalid
      warn "[archer] Unable to save history"
      false
    end

    def clear
      quietly do
        Archer::History.where(user: user).delete_all
      end
      history_object.clear if history_object
      true
    end

    private

    def history_object
      cls = IRB.CurrentContext&.io&.class
      cls && cls.const_defined?(:HISTORY) ? cls::HISTORY : nil
    end

    def quietly
      ActiveRecord::Base.logger.silence do
        yield
      end
    end
  end
end
