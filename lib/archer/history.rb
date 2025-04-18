module Archer
  class History < ActiveRecord::Base
    self.table_name = "archer_history"

    serialize :commands, coder: Coder
  end
end
