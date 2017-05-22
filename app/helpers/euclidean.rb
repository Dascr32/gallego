module Helpers
  module Euclidean
    class Compute
      extend Helpers::Algorithms

      def self.style(values)
        styles = LearningStyle.all
        distances = {}

        styles.each do |style|
          style_values = [style.ec, style.or, style.ca, style.ea]
          distances[style.id] = euclidean_distance(values, style_values)
        end
        LearningStyle.find(distances.key(knn(distances.values, 1).first))
      end

      def self.style_alt(values)
        find_similar_student(values, %w(campus gender gpa))
      end

      def self.campus(values)
        find_similar_student(values, %w(style gender gpa))
      end

      def self.gender(values)
        find_similar_student(values, %w(style campus gpa))
      end

      def self.professor(values)
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

      def self.network(values)
        networks = Network.all
        distances = {}
        values = strs_to_points(values)

        networks.each do |net|
          net_values = strs_to_points([net.reliability, net.links, 
                                       net.capacity, net.cost])
          distances[net.id] = euclidean_distance(values, net_values)
        end
        Network.find(distances.key(knn(distances.values, 1).first))
      end

      private

      def self.find_similar_student(comp_vals, attr)
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
    end
  end
end
