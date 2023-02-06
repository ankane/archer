# dependencies
require "active_support/core_ext/module/attribute_accessors"

# modules
require "archer/engine" if defined?(Rails)
require "archer/irb"
require "archer/version"

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
    Readline::HISTORY.clear if defined?(Readline)
    Reline::HISTORY.clear if defined?(Reline)
    true
  end

  def self.start
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
    quietly do
      history = Archer::History.where(user: user).first_or_initialize
      history.commands = history_object.to_a.last(limit).join("\n")
      history.save!
    end
  rescue ActiveRecord::StatementInvalid
    warn "[archer] Unable to save history"
  end

  # private
  # TODO use IRB.CurrentContext.io.class::HISTORY
  def self.history_object
    reline? ? Reline::HISTORY : Readline::HISTORY
  end

  # private
  def self.reline?
    if defined?(IRB::RelineInputMethod)
      IRB.CurrentContext.io.is_a?(IRB::RelineInputMethod)
    else
      IRB.CurrentContext.io.is_a?(IRB::ReidlineInputMethod)
    end
  rescue
    false
  end

  # private
  def self.quietly
    ActiveRecord::Base.logger.silence do
      yield
    end
  end
end
