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

    def compute_style_alt(values)
      find_similar_student(values, %w(campus gender gpa))
    end

    def compute_campus(values)
      find_similar_student(values, %w(style gender gpa))
    end

    def compute_gender(values)
      find_similar_student(values, %w(style campus gpa))
    end

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

    def find_similar_student(comp_vals, attr)
      students = Student.all
      distances = {}
      values = [to_point(comp_vals[0]), to_point(comp_vals[1]), comp_vals[2]]

      students.each do |student|
        student_values = [to_point(student.send(attr[0])),
                          to_point(student.send(attr[1])),
                          student.send(attr[2])]

        distances[student.id] = euclidean_distance(values, student_values)
      end
      Student.find(distances.key(knn(distances.values, 1).first))
    end

    private

    def to_point(key)
      STYLES_POINTS.merge(GENDERS_POINTS)
                   .merge(CAMPUS_POINTS)
                   .fetch(key.downcase.to_sym)
    end

    def to_i_or_f(string)
      string.match('\.').nil? ? string.to_i : string.to_f
    end
  end
end
