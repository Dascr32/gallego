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

    def compute_professor(values)
      professors = Professor.all
      distances = {}
      values = strs_to_points(values)

      professors.each do |prof|
        prof_values = prof.to_a
        # Pop id & category value
        prof_values.shift
        prof_values.pop
        prof_values = strs_to_points(prof_values)

        distances[prof.id] = euclidean_distance(values, prof_values)
      end
      Professor.find(distances.key(knn(distances.values, 1).first))
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
      values = strs_to_points(comp_vals)

      students.each do |student|
        student_values = strs_to_points([student.send(attr[0]),
                                         student.send(attr[1]),
                                         student.send(attr[2])])

        distances[student.id] = euclidean_distance(values, student_values)
      end
      Student.find(distances.key(knn(distances.values, 1).first))
    end

    private

    def strs_to_points(values)
      values.each_with_index do |value, index|
        values[index] = value.to_i.zero? ? to_point(value) : value
      end
    end

    def to_point(key)
      STYLES_POINTS.merge(GENDERS_POINTS)
                   .merge(CAMPUS_POINTS)
                   .merge(PROFESSORS_POINTS)
                   .fetch(key.downcase.to_sym)
    end

    def to_i_or_f(string)
      string.match('\.').nil? ? string.to_i : string.to_f
    end
  end
end
