ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
require_relative '../config/environment'

class AlgorithmsTest < Minitest::Test
  include Rack::Test::Methods

  def setup
    @algorithms = Object.new.extend(Helpers::Algorithms)
  end

  def test_euclidean_distance
    vector1 = [1, 2, 3]
    vector2 = [4, 0, -3]

    assert_equal 7, @algorithms.euclidean_distance(vector1, vector2)
  end

  def test_knn
    train_dataset = [[1, 2, 3], [4, 0, -3], [5, 9, 0]]
    sample = [2, 6, 8]
    # Distances for train_dataset: 6.480, 12.688, 9.055
    distances = []

    train_dataset.each_with_index do |set, index|
      distances[index] = @algorithms.euclidean_distance(set, sample)
    end

    nearest_two_neighbors = @algorithms.knn(distances, 2)

    assert_equal 2, nearest_two_neighbors.count
    assert_in_delta 6.480, nearest_two_neighbors[0]
    assert_in_delta 9.055, nearest_two_neighbors[1]
  end
end
