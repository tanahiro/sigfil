require "#{__dir__}/test_helper"

require "sigfil/statistical_outlier_removal"

class StatisticalOutlierRemovalTest < Minitest::Test
  def test_apply_filter_1d_1
    filename = File.join(__dir__, "data", "1d-1.dat")
    nm = load_data_1d(filename)

    mean_k  = 5
    std_mul = 3.0
    sor = SigFil::StatisticalOutlierRemoval.new(nm, mean_k, std_mul)
    actual = sor.apply_filter.col(1)

    filename = File.join(__dir__, "data", "1d-1_sor.dat")
    expected = load_data(filename)

    assert_equal(expected.shape, actual.shape)
    assert_equal(expected.to_a, actual.to_a)
  end

  def test_apply_filter_2d_circle
    filename = File.join(__dir__, "data", "2d-circle.dat")
    nm = load_data(filename)

    mean_k  = 5
    std_mul = 2
    sor = SigFil::StatisticalOutlierRemoval.new(nm, mean_k, std_mul)
    actual = sor.apply_filter

    filename = File.join(__dir__, "data", "2d-circle_sor.dat")
    expected = load_data(filename)

    assert_equal(expected.shape, actual.shape)
    assert_equal(expected.to_a, actual.to_a)
  end
end

