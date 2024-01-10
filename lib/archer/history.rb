module Archer
  class History < ActiveRecord::Base
    self.table_name = "archer_history"

    if ActiveRecord::VERSION::STRING.to_f >= 7.1
      serialize :commands, coder: Coder
    else
      serialize :commands, Coder
    end
  end
end
