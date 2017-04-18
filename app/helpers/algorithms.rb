# Includes all the algorithms to crunch data and guess
# things
module Helpers
  module Algorithms
    include Helpers::StaticData

    def compute_style(values)
      styles = LearningStyle.all
      distances = {}

      styles.each do |style|
        style_values = [style.ec, style.or, style.ca, style.ea]
        distances[style.id] = euclidean_distance(values, style_values)
      end
      LearningStyle.find(distances.key(knn(distances.values, 1).first))
    end

    def compute_campus(values)
      students = Student.all
      distances = {}

      # Get distance of style & gender (strings)
      values[0] = to_dist(values[0])
      values[1] = to_dist(values[1])

      students.each do |student|
        student_values = [to_dist(student.style), to_dist(student.gender), student.gpa]
        distances[student.id] = euclidean_distance(values, student_values)
      end
      Student.find(distances.key(knn(distances.values, 1).first))
    end

    def euclidean_distance(vector1, vector2)
      sum = 0
      vector1.zip(vector2).each do |subset|
        subset_nums = subset.map { |i| i.is_a?(String) ? i.to_i : i }
        sum += subset_nums.reduce(:-)**2
      end
      Math.sqrt(sum)
    end

    def knn(distances, k)
      distances.sort { |x, y| x <=> y }.take(k)
    end

    private

    def to_dist(value)
      STYLES_POINTS.merge(GENDERS_POINTS).fetch(value.downcase.to_sym)
    end
  end
end
