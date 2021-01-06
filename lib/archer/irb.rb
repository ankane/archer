module Archer
  module Irb
    # needs to run after conf[:MAIN_CONTEXT] is set
    def eval_input(*)
      Archer.start
      super
    end
  end
end
