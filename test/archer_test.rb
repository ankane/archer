require "test_helper"

class ArcherTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Archer::VERSION
  end
end
