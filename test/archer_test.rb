require_relative "test_helper"

class ArcherTest < Minitest::Test
  def setup
    Archer.clear
    Archer::History.delete_all
  end

  def test_works
    # TODO use IRB
    ["1 + 2", "2 * 3"].each do |cmd|
      Archer.history_object.push(cmd)
    end
    Archer.save

    assert_equal 1, Archer::History.count
    history = Archer::History.last
    assert_equal "test", history.user
    assert_equal "1 + 2\n2 * 3", history.commands
  end
end
