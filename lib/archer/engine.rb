module Archer
  class Engine < Rails::Engine
    console do
      Archer.history_file ||= Rails.root.join("tmp", ".irb-history")
      Archer.start

      at_exit do
        Archer.save
      end
    end
  end
end
