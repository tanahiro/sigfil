require "nmatrix"
require "flann"

module SigFil
  class StatisticalOutlierRemoval

    attr_accessor :mean_k, :std_mul

    ##
    # +mean_k+: Number of points to use mean distance estimation
    # +std_mul+: Standard deviation multipliera threshold
    def initialize dataset, mean_k = 2, std_mul = 0.0
      @dataset = dataset
      @mean_k  = mean_k
      @std_mul = std_mul
    end

    def apply_filter scale_factors = nil
      Flann.set_distance_type!(:l2)

      if scale_factors
        unless scale_factors.size == @dataset.cols
          raise ArgumentError, "scale_factors.size != dataset.cols"
        else
          dataset = @dataset.clone
          scale_factors.each_with_index do |s, i|
            dataset[0..-1, i] *= s
          end
        end
      else
        dataset = @dataset
      end

      searcher = Flann::Index.new(@dataset) do |params|
        params[:trees] = @mean_k
      end
      searcher.build!

      distances = Array.new(@dataset.rows, 0.0)
      @dataset.each_row(:clone).with_index do |row, iii|
        _, dis= searcher.nearest_neighbors(row, @mean_k + 1)

        distances[iii] = NMatrix[*dis[1..-1]].mean[0]
      end

      nm_d   = NMatrix[*distances]
      d_mean = nm_d.mean[0]
      d_std  = nm_d.std[0]
      d_th   = d_mean + @std_mul*d_std

      filtered = []
      distances.each_with_index do |d, i|
        if d <= d_th
          filtered << @dataset.row(i).to_a
        end
      end

      return NMatrix[*filtered]
    end
  end
end

