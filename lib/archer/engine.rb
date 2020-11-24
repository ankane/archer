module Archer
  class Engine < Rails::Engine
    console do
      # TODO remove in 0.3.0
      Archer.history_file ||= Rails.root.join("tmp", ".irb-history")

      # need IRB context to be ready before Archer.start
      ::IRB::Irb.prepend(Archer::Irb)

      at_exit do
        Archer.save
      end
    end
  end
end
