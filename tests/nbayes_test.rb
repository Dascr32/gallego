ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
require_relative '../config/environment'

class AlgorithmsTest < Minitest::Test
  include Rack::Test::Methods
  include Helpers::Algorithms

  def setup
    @nbayes = NaiveBayes.new(Network.all, category: 'category')
  end

  def test_categories_available_should_be_unique
    assert_equal 2, @nbayes.categories_available.size
    assert %w(A B), @nbayes.categories_available
  end

  def test_category_count
    assert_equal 16, @nbayes.category_count('A')
  end

  def test_probs_values
    value = @nbayes.prob_values(attr: :reliability, val: 2, category: 'A')
    assert_equal 16, value[:n]
    assert_equal 8, value[:n_c]
    assert_in_delta 0.25, value[:p]
  end

  def test_classification
    element = { reliability: 2, links: 10, capacity: 'Medium', cost: 'Medium' }
    category = @nbayes.classify(element)
    assert_equal 'A', category[:category]
  end
end
