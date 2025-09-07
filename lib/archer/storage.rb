module Archer
  class Storage
    def load(user:)
      quietly do
        Archer::History.find_by(user: user)&.commands
      end
    rescue ActiveRecord::StatementInvalid
      raise "Create table to enable history"
    end

    def save(commands, user:)
      quietly do
        history = Archer::History.where(user: user).first_or_initialize
        history.commands = commands
        history.save!
      end
    end

    def clear(user:)
      quietly do
        Archer::History.where(user: user).delete_all
      end
    end

    private

    def quietly
      ActiveRecord::Base.logger.silence do
        yield
      end
    end
  end
end
