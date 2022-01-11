module Archer
  class Engine < Rails::Engine
    console do
      # need IRB context to be ready before Archer.start
      ::IRB::Irb.prepend(Archer::Irb)

      at_exit do
        Archer.save if Archer.save_session
      end
    end
  end
end
