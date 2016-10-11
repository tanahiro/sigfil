require "nmatrix"
require "daru"

module SigFil
  class VoxelGrid
    attr_accessor :dataset
    attr_reader :leaf_size

    def initialize dataset, leaf_size
      @dataset   = dataset
      @leaf_size = leaf_size
      get_inverse_leaf_size
      
    end

    def apply_filter
      min, max = get_min_max

      bb_min, bb_max = get_bb(min, max)

      #div_b = bb_max.zip(bb_min).map {|x| x[0] - x[1] + 1}

      index = []
      @dataset.each_row do |pt|
        id = (pt*@inverse_leaf_size - bb_min).floor
        index << id.to_a
      end

      grid_idx = {}
      df = Daru::DataFrame.rows(index)
      #df.sort!(df.vectors)
      df.each_row_with_index do |row, id|
        grid_idx[row.to_a] ||= []
        grid_idx[row.to_a] << id
      end

      voxel_ary = []
      grid_idx.each do |g_id, d_id|
        ary = d_id.map {|i| @dataset.row(i).to_a}
        nm = NMatrix[*ary]
        voxel_ary << nm.mean(0).to_a
      end

      return NMatrix[*voxel_ary]
    end

    def get_min_max
      min = @dataset.min(0)
      max = @dataset.max(0)

      return min, max
    end

    ##
    # Get bounding box
    def get_bb min, max
      bb_min = (min*@inverse_leaf_size).floor
      bb_max = (max*@inverse_leaf_size).floor

      return bb_min, bb_max
    end

    def leaf_size= leaf_size
      @leaf_size = leaf_size
    end

    def get_inverse_leaf_size
      @inverse_leaf_size = NMatrix[@leaf_size.map {|x| 1.0/x}]
    end
  end
end

