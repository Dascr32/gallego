ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
require_relative '../config/environment'

class AlgorithmsTest < Minitest::Test
  include Rack::Test::Methods
  include Helpers::Algorithms

  def app
    Gallego
  end

  def setup
    @style_a, @style_b = create_style_dataset
    @student_a, @student_b = create_student_dataset
  end

  def teardown
    @style_a.destroy
    @style_b.destroy
    @student_a.destroy
    @student_b.destroy
  end

  def test_euclidean_distance
    vector1 = [1, 2, 3]
    vector2 = [4, 0, -3]

    assert_equal 7, euclidean_distance(vector1, vector2)
  end

  def test_knn
    train_dataset = [[1, 2, 3], [4, 0, -3], [5, 9, 0]]
    sample = [2, 6, 8]
    # Distances for train_dataset: 6.480, 12.688, 9.055
    distances = []

    train_dataset.each_with_index do |set, index|
      distances[index] = euclidean_distance(set, sample)
    end

    nearest_two_neighbors = knn(distances, 2)

    assert_equal 2, nearest_two_neighbors.count
    assert_in_delta 6.480, nearest_two_neighbors[0]
    assert_in_delta 9.055, nearest_two_neighbors[1]
  end

  def test_computed_style_should_be_same
    values = [@style_a.ec, @style_a.or, @style_a.ca, @style_a.ea]
    computed_style = compute_style(values)

    assert_equal @style_a.style, computed_style.style
  end

  def test_computed_style_should_be_acomodador
    computed_style = compute_style([17, 15, 15, 19])

    # Note that ec: 17, or: 15, ca: 15, ea:19
    # are very similar to set_b, so the computed style
    # should be set_b style 'acomodador'
    assert_equal @style_b.style, computed_style.style
  end

  def test_computed_campus_should_be_same
    values = [@student_a.style, @student_a.gender, @student_a.gpa]
    computed_style = compute_campus(values)

    assert_equal @student_a.campus.downcase, computed_style.campus.downcase
  end

  def test_computed_campus_should_be_paraiso
    computed_style = compute_campus(['ACOMODADOR', 'M', 7.5])

    assert_equal @student_b.campus.downcase, computed_style.campus.downcase
  end

  def test_computed_campus_should_be_case_insensitive
    computed_style = compute_campus(['AcomoDadoR', 'm', 7.5])

    assert_equal @student_b.campus.downcase, computed_style.campus.downcase
  end

  private

  def create_style_dataset
    set_a = LearningStyle.create(campus: 'PA', ec: 12, or: 16, ca: 18, ea: 21,
                                 ca_ec: 6, ea_or: 5, style: 'CONVERGENTE')
    set_b = LearningStyle.create(campus: 'PA', ec: 15, or: 12, ca: 15, ea: 19,
                                 ca_ec: 0, ea_or: 7, style: 'ACOMODADOR')
    set_a.save
    set_b.save
    [set_a.reload, set_b.reload]
  end

  def create_student_dataset
    set_a = Student.create(gender: 'M', campus: 'TURRIALBA', gpa: 7.54, ec: 15, or: 12,
                           ca: 20, ea: 15, ca_ec: 5, ea_or: 3, style: 'CONVERGENTE')
    set_b = Student.create(gender: 'F', campus: 'PARAISO', gpa: 7.82, ec: 17, or: 15,
                           ca: 15, ea: 19, ca_ec: -2, ea_or: 4, style: 'ACOMODADOR')
    set_a.save
    set_b.save
    [set_a.reload, set_b.reload]
  end
end
