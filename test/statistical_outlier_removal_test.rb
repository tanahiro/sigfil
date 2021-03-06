require "#{__dir__}/test_helper"

require "sigfil/statistical_outlier_removal"

class StatisticalOutlierRemovalTest < Minitest::Test
  def test_apply_filter_1d_1
    filename = File.join(__dir__, "data", "1d-1.dat")
    nm = load_data_1d(filename)

    mean_k  = 5
    std_mul = 1.5
    sor = SigFil::StatisticalOutlierRemoval.new(nm, mean_k, std_mul)
    actual = sor.apply_filter([0.1, 1]).col(1)

    filename = File.join(__dir__, "data", "1d-1_sor.dat")
    expected = load_data(filename)

    assert_equal(expected.shape, actual.shape)
    assert_equal(expected.to_a, actual.to_a)

    actual   = sor.removed_indices
    expected = [10, 50, 70]
    assert_equal(expected.to_a, actual.to_a)
  end

  def test_apply_filter_1d_1_flann
    filename = File.join(__dir__, "data", "1d-1.dat")
    nm = load_data_1d(filename)

    mean_k  = 5
    std_mul = 1.5
    sor = SigFil::StatisticalOutlierRemoval.new(nm, mean_k, std_mul, :flann)
    actual = sor.apply_filter([0.1, 1]).col(1)

    assert_instance_of(NMatrix, actual)
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

    actual = sor.removed_indices
    expected = [10, 30, 70]
    assert_equal(expected, actual)
  end
end

