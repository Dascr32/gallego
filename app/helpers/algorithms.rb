# Includes all the algorithms to crunch data and guess
# things
module Algorithms
  def compute_style(values)
    styles = LearningStyle.all
    best_guess = { style_id: nil, distance: 100 }

    styles.each do |style|
      style_values = [style.ec, style.or, style.ca, style.ea]
      distance = euclidean_distance(values, style_values)

      if distance < best_guess[:distance]
        best_guess = { style_id: style.id, distance: distance }
      end
    end
    LearningStyle.find(best_guess[:style_id])
  end

  def euclidean_distance(vector1, vector2)
    sum = 0
    vector1.zip(vector2).each do |subset|
      sum += subset.map(&:to_i).reduce(:-)**2
    end
    Math.sqrt(sum)
  end
end
