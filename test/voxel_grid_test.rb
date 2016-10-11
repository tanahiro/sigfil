require "#{__dir__}/test_helper"

require "sigfil/voxel_grid"

class VoxelGridTest < Minitest::Test
  def test_apply_filter_3d_random
    filename = File.join(__dir__, "data", "3d-random.dat")
    nm = load_data(filename)

    voxel_grid = SigFil::VoxelGrid.new(nm, [2, 2, 2])
    actual     = voxel_grid.apply_filter

    filename = File.join(__dir__, "data", "3d-random-voxel_2.dat")
    expected = load_data(filename)

    assert_equal(expected.shape, actual.shape)
    assert_equal(expected.to_a, actual.to_a)
  end
end
