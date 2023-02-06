module Archer
  class Engine < Rails::Engine
    console do
      # need IRB context to be ready before Archer.start
      ::IRB::Irb.prepend(Archer::Irb)
    end
  end
end
