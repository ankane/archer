module Archer
  class Engine < Rails::Engine
    console do
      # need IRB context to be ready before Archer.start
      require "irb"
      ::IRB::Irb.prepend(Archer::Irb)
    end
  end
end
