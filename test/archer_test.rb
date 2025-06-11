require_relative "test_helper"

class ArcherTest < Minitest::Test
  def setup
    Archer::History.delete_all
  end

  def test_tty
    STDIN.stub(:tty?, true) { setup_irb }

    assert_equal true, Archer.clear

    assert_equal 0, Archer::History.count

    run_commands(["1 + 2", "2 * 3"])

    assert_equal true, Archer.save

    assert_equal 1, Archer::History.count
    history = Archer::History.last
    assert_equal "test", history.user
    assert_equal ["1 + 2", "2 * 3"], history.commands
  end

  def test_non_tty
    STDIN.stub(:tty?, false) { setup_irb }

    assert_equal true, Archer.clear

    assert_equal 0, Archer::History.count

    run_commands(["1 + 2", "2 * 3"])

    assert_equal false, Archer.save

    assert_equal 0, Archer::History.count
  end

  private

  def setup_irb
    capture_io do
      @irb = IRB::Irb.new
    end
    IRB.conf[:MAIN_CONTEXT] = @irb.context
  end

  def run_commands(commands)
    # TODO use IRB
    commands.each do |cmd|
      Archer.send(:history_object).push(cmd) if Archer.send(:history_object)
    end
  end
end
