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
    @prof_a = create_professor_dataset.first
    @net_a = create_network_dataset.first
  end

  def teardown
    @style_a.destroy
    @style_b.destroy
    @student_a.destroy
    @student_b.destroy
    @prof_a.destroy
    @net_a.destroy
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
    computed = compute_style(values)

    assert_equal @style_a.style, computed.style
  end

  def test_computed_style_should_be_acomodador
    computed = compute_style([17, 15, 15, 19])

    # Note that ec: 17, or: 15, ca: 15, ea:19
    # are very similar to set_b, so the computed style
    # should be set_b style 'acomodador'
    assert_equal @style_b.style, computed.style
  end

  def test_computed_campus_should_be_same
    values = [@student_a.style, @student_a.gender, @student_a.gpa]
    computed = compute_campus(values)

    assert_equal @student_a.campus.downcase, computed.campus.downcase
  end

  def test_computed_campus_should_be_paraiso
    computed = compute_campus(['ACOMODADOR', 'M', 7.5])

    assert_equal @student_b.campus.downcase, computed.campus.downcase
  end

  def test_computed_campus_should_be_case_insensitive
    computed = compute_campus(['AcomoDadoR', 'm', 7.5])

    assert_equal @student_b.campus.downcase, computed.campus.downcase
  end

  def test_computed_gender_should_be_same
    values = [@student_a.style, @student_a.campus, @student_a.gpa]
    computed = compute_gender(values)

    assert_equal @student_a.gender, computed.gender
  end

  def test_computed_gender_should_be_masculino
    computed = compute_gender(['ACOMODADOR', 'PARAISO', 7.82])

    assert_equal @student_b.gender, computed.gender
  end

  def test_computed_style_alt_should_be_same
    values = [@student_a.campus, @student_a.gender, @student_a.gpa]
    computed = compute_style_alt(values)

    assert_equal @student_a.style, computed.style
  end

  def test_computed_style_alt_should_be_acomodador
    computed = compute_style_alt(['PARAISO', 'F', 7.82])

    assert_equal @student_b.style, computed.style
  end

  def test_computed_professor_should_be_same
    values = @prof_a.to_a
    values.shift
    values.pop
    computed = compute_professor(values)

    assert_equal @prof_a.category, computed.category
  end

  def test_computed_network_should_be_same
    values = [@net_a.reliability, @net_a.links, @net_a.capacity, @net_a.cost]
    computed = compute_network(values)

    assert_equal @net_a.category, computed.category
  end

  private

  # Better using fixtures, looks awful
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
    set_a = Student.create(gender: 'M', campus: 'TURRIALBA', gpa: 7.54, ec: 15,
                           or: 12, ca: 20, ea: 15, ca_ec: 5, ea_or: 3,
                           style: 'CONVERGENTE')
    set_b = Student.create(gender: 'F', campus: 'PARAISO', gpa: 7.82, ec: 17,
                           or: 15, ca: 15, ea: 19, ca_ec: -2, ea_or: 4,
                           style: 'ACOMODADOR')
    set_a.save
    set_b.save
    [set_a.reload, set_b.reload]
  end

  def create_professor_dataset
    set_a = Professor.create(age: 3, gender: 'F', self_avaluation: 'I',
                             times_teaching: 1, background: 'ND',
                             skills_with_pc: 'A', exp_with_web_tech: 'N',
                             exp_with_web_sites: 'S', category: 'Beginner')

    set_b = Professor.create(age: 2, gender: 'F', self_avaluation: 'I',
                             times_teaching: 3, background: 'O',
                             skills_with_pc: 'H', exp_with_web_tech: 'S',
                             exp_with_web_sites: 'O', category: 'Advanced')
    set_a.save
    set_b.save
    [set_a.reload, set_b.reload]
  end

  def create_network_dataset
    set_a = Network.create(reliability: 2, links: 7,
                           capacity: 'High', cost: 'High', category: 'A')

    set_b = Network.create(reliability: 4, links: 18,
                           capacity: 'Medium', cost: 'High', category: 'B')
    set_a.save
    set_b.save
    [set_a.reload, set_b.reload]
  end
end
