require_relative "test_helper"

class ArcherTest < Minitest::Test
  def setup
    Archer::History.delete_all
  end

  def test_tty
    stub_method(STDIN, :tty?, true) { setup_irb }

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
    stub_method(STDIN, :tty?, false) { setup_irb }

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
      Archer.send(:history).push(cmd) if Archer.send(:history)
    end
  end

  def stub_method(cls, method, code)
    original_code = cls.method(method)
    begin
      cls.singleton_class.undef_method(method)
      cls.define_singleton_method(method, code.respond_to?(:call) ? code : ->(*) { code })
      yield
    ensure
      cls.singleton_class.undef_method(method) if cls.singleton_class.method_defined?(method)
      cls.define_singleton_method(method, original_code)
    end
  end
end
