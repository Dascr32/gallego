# Includes all the algorithms to crunch data and guess
# things
module Helpers
  module Algorithms
    class Data
      include Helpers::StaticData

      def self.strs_to_points(values)
        values.each_with_index do |value, index|
          # Only convert string literals
          values[index] = value.to_i.zero? ? to_point(value) : value
        end
      end

      def self.to_point(key)
        STYLES_POINTS.merge(GENDERS_POINTS)
                     .merge(CAMPUS_POINTS)
                     .merge(PROFESSORS_POINTS)
                     .merge(NETWORKS_POINTS)
                     .fetch(key.downcase.to_sym)
      end

      def self.to_i_or_f(string)
        string.match('\.').nil? ? string.to_i : string.to_f
      end
    end

    class EuclideanDistance
      def self.distance(vector1, vector2)
        sum = 0
        vector1.zip(vector2).each do |subset|
          subset_nums = subset.map { |i| i.is_a?(String) ? Data.to_i_or_f(i) : i }
          sum += subset_nums.reduce(:-)**2
        end
        Math.sqrt(sum)
      end

      def self.knn(distances, k)
        distances.sort { |x, y| x <=> y }.take(k)
      end
    end

    class NaiveBayes
      def initialize(dataset, category:)
        @dataset = JSON.parse(dataset.to_json)
        @dataset_raw = dataset
        @category_name = category.to_s
        @probs ||= train
      end

      def train
        probs = {}
        if cache_available?
          probs = cached_probabilities
        else
          probs = calc_probabilities
          cache_probabilities(probs)
        end
        probs
      end

      # element: { attribute1: attribute1_value, ... }
      def classify(element)
        class_prob = {}
        categories_available.map do |c|
          probs = element.map { |k, v| @probs.fetch(prob_id(k, v, c), 1) }.reduce(:*)
          class_prob[c] = (category_count(c).to_f / @dataset.count) * probs
        end
        [class_prob.key(class_prob.values.max), class_prob.values.max]
      end

      def prob_values(attr:, val:, category:)
        values = {}
        values[:n]   = category_count(category)
        values[:n_c] = ocurrences(attr: attr, val: val, category: category)
        values[:p]   = 1.0 / uniq_values(attr).count
        values[:m]   = 1
        values
      end

      def categories_available
        uniq_values(@category_name).map do |h|
          h[@category_name]
        end
      end

      def category_count(category_value)
        ocurrences(attr: @category_name, val: category_value)
      end

      private

      def calc_probabilities
        probs = {}
        @dataset.each do |h|
          category = h[@category_name]
          h.each do |k, v|
            next if ['id', @category_name].include?(k)

            values = prob_values(attr: k, val: v, category: category)
            probs[prob_id(k, v, category)] = probability(values)
          end
        end
        probs
      end

      def probability(values)
        (values[:n_c] + (values[:m] * values[:p])) / values[:n] + values[:m]
      end

      def ocurrences(attr:, val:, category: nil)
        data = @dataset
        data = data.select { |row| row[@category_name] == category } if category
        data.count { |row| row[attr.to_s] == val }
      end

      def uniq_values(key)
        @dataset.uniq { |row| row[key.to_s] }
      end

      def cache_available?
        Gallego.settings.cache.exists(cache_id)
      end

      def cache_probabilities(probs)
        Gallego.settings.cache.set(cache_id, probs.to_json)
      end

      def cached_probabilities
        JSON.parse(Gallego.settings.cache.get(cache_id))
      end

      def prob_id(attri_name, attri_value, category_value)
        "#{attri_name}_#{attri_value}_#{category_value}"
      end

      def cache_id
        "#{@dataset_raw.first.class.model_name}_probs"
      end
    end
  end
end
