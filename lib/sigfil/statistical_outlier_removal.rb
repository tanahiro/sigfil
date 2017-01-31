require "nmatrix"
require "flann"
require "algorithms"

module SigFil
  class StatisticalOutlierRemoval
    include Math

    attr_accessor :mean_k, :std_mul, :dataset, :searcher
    attr_reader :removed_indices

    SEARCHER = [:kdtree, :flann]

    ##
    # +mean_k+: Number of points to use mean distance estimation
    # +std_mul+: Standard deviation multipliera threshold
    def initialize dataset, mean_k = 2, std_mul = 0.0, searcher = :kdtree
      @dataset  = dataset
      @mean_k   = mean_k
      @std_mul  = std_mul
      unless SEARCHER.include?(searcher)
        raise ArgumentError, "Unknown searcher type: #{searcher}"
      else
        @searcher = searcher
      end
    end

    def apply_filter scale_factors = nil
      if @searcher == :flann
        Flann.set_distance_type!(:l2)
      end

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

      case @searcher
      when :flann
        searcher = Flann::Index.new(@dataset) do |params|
          params[:algorithm]    = :kdtree
          params[:trees]        = 4
          params[:centers_init] = :gonzales
        end
        searcher.build!
      when :kdtree
        dataset_h = dataset.to_a.each_with_index.map {|pt, i| [i, pt]}.to_h
        searcher  = Containers::KDTree.new(dataset_h)
      end

      distances = Array.new(dataset.rows, 0.0)
      dataset.each_row(:clone).with_index do |row, iii|
        case @searcher
        when :flann
          _, dis= searcher.nearest_neighbors(row, @mean_k + 1)
          distances[iii] = NMatrix[*dis[1..-1]].mean[0]
        when :kdtree
          dis = searcher.find_nearest(row.to_a, @mean_k + 1).map do
            |r| sqrt(r[0])
          end
        end

        distances[iii] = NMatrix[*dis[1..-1]].mean[0]
      end

      nm_d   = NMatrix[*distances]
      d_mean = nm_d.mean[0]
      d_std  = nm_d.std[0]
      d_th   = d_mean + @std_mul*d_std

      filtered         = []
      @removed_indices = []
      distances.each_with_index do |d, i|
        if d <= d_th
          filtered << @dataset.row(i).to_a
        else
          @removed_indices << i
        end
      end

      return NMatrix[*filtered]
    end
  end
end

