module Helpers
  module Euclidean
    class Compute
      class << self
        include Helpers::Algorithms

        def style(values)
          styles = LearningStyle.all
          distances = {}

          styles.each do |style|
            style_vals = [style.ec, style.or, style.ca, style.ea]
            distances[style.id] = EuclideanDistance.distance(values, style_vals)
          end
          LearningStyle.find(closest_distance(distances))
        end

        def style_alt(values)
          find_similar_student(values, %w(campus gender gpa))
        end

        def campus(values)
          find_similar_student(values, %w(style gender gpa))
        end

        def gender(values)
          find_similar_student(values, %w(style campus gpa))
        end

        def professor(values)
          professors = Professor.all
          distances = {}
          values = Data.strs_to_points(values)

          professors.each do |prof|
            prof_values = prof.to_a(id_category: false)
            prof_values = Data.strs_to_points(prof_values)

            distances[prof.id] = EuclideanDistance.distance(values, prof_values)
          end
          Professor.find(closest_distance(distances))
        end

        def network(values)
          networks = Network.all
          distances = {}
          values = Data.strs_to_points(values)

          networks.each do |net|
            net_values = Data.strs_to_points([net.reliability, net.links,
                                              net.capacity, net.cost])
            distances[net.id] = EuclideanDistance.distance(values, net_values)
          end
          Network.find(closest_distance(distances))
        end

        private

        def find_similar_student(comp_vals, attr)
          students = Student.all
          distances = {}
          values = Data.strs_to_points(comp_vals)

          students.each do |stud|
            stud_vals = Data.strs_to_points([stud.send(attr[0]),
                                             stud.send(attr[1]),
                                             stud.send(attr[2])])
            distances[stud.id] = EuclideanDistance.distance(values, stud_vals)
          end
          Student.find(closest_distance(distances))
        end

        def closest_distance(distances)
          distances.key(EuclideanDistance.knn(distances.values, 1).first)
        end
      end
    end
  end
end
