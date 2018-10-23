# dependencies
require "active_support/core_ext/module/attribute_accessors"

# modules
require "archer/engine" if defined?(Rails)
require "archer/version"

module Archer
  autoload :History, "archer/history"

  mattr_accessor :limit
  self.limit = 200

  mattr_accessor :user
  self.user = ENV["USER"]

  mattr_accessor :history_file

  def self.clear
    quietly do
      Archer::History.where(user: user).delete_all
    end
    Readline::HISTORY.clear
    true
  end

  def self.start
    history = nil
    begin
      quietly do
        history = Archer::History.where(user: user).first_or_initialize
      end
    rescue
      warn "[archer] Create table to enable history"
    end

    if history && history.persisted?
      Readline::HISTORY.push(*history.commands.split("\n"))
    end
  end

  def self.save
    quietly do
      history = Archer::History.where(user: user).first_or_initialize
      history.commands = Readline::HISTORY.to_a[-limit..-1].join("\n")
      history.save
    end
  rescue
    # do nothing
  end

  # private
  def self.quietly
    ActiveRecord::Base.logger.silence do
      yield
    end
  end
end
