require "#{__dir__}/test_helper"

class SigfilTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::SigFil::VERSION
  end
end
