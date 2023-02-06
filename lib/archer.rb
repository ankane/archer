# dependencies
require "active_support/core_ext/module/attribute_accessors"

# modules
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

  def self.clear
    quietly do
      Archer::History.where(user: user).delete_all
    end
    history_object.clear if history_object
    true
  end

  def self.start
    if !history_object
      warn "[archer] History not enabled"
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
      commands = history.commands.split("\n")
      history_object.push(*commands)
    end
  end

  def self.save
    return unless history_object

    quietly do
      history = Archer::History.where(user: user).first_or_initialize
      history.commands = history_object.to_a.last(limit).join("\n")
      history.save!
    end
  rescue ActiveRecord::StatementInvalid
    warn "[archer] Unable to save history"
  end

  # private
  def self.history_object
    cls = IRB.CurrentContext.io.class
    cls.const_defined?(:HISTORY) ? cls::HISTORY : nil
  end

  # private
  def self.quietly
    ActiveRecord::Base.logger.silence do
      yield
    end
  end
end
