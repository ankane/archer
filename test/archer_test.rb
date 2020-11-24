require_relative "test_helper"

class ArcherTest < Minitest::Test
  def test_user
    Archer.user = "test"
    assert_equal "test", Archer.user
  end
end
