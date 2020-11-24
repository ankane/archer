module Archer
  module Irb
    def run(*)
      Archer.start
      super
    end
  end
end
