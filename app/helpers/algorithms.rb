# Includes all the algorithms to crunch data and guess
# things
module Helpers
  module Algorithms
    include Helpers::StaticData

    def euclidean_distance(vector1, vector2)
      sum = 0
      vector1.zip(vector2).each do |subset|
        subset_nums = subset.map { |i| i.is_a?(String) ? to_i_or_f(i) : i }
        sum += subset_nums.reduce(:-)**2
      end
      Math.sqrt(sum)
    end

    def knn(distances, k)
      distances.sort { |x, y| x <=> y }.take(k)
    end

    def strs_to_points(values)
      values.each_with_index do |value, index|
        # Only convert string literals
        values[index] = value.to_i.zero? ? to_point(value) : value
      end
    end

    private

    def to_point(key)
      STYLES_POINTS.merge(GENDERS_POINTS)
                   .merge(CAMPUS_POINTS)
                   .merge(PROFESSORS_POINTS)
                   .merge(NETWORKS_POINTS)
                   .fetch(key.downcase.to_sym)
    end

    def to_i_or_f(string)
      string.match('\.').nil? ? string.to_i : string.to_f
    end
  end
end
