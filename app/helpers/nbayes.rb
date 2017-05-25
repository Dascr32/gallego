module Helpers
  module NBayes
    class Compute
      class << self
        include Helpers::Algorithms

        def style(values)
          compute(data: LearningStyle.all, cat: 'style', vals: values)
        end

        def style_alt(values)
          compute(data: Student.all, cat: 'style', vals: values)
        end

        def campus(values)
          compute(data: Student.all, cat: 'campus', vals: values)
        end

        def gender(values)
          compute(data: Student.all, cat: 'gender', vals: values)
        end

        def professor(values)
          compute(data: Professor.all, cat: 'category', vals: values)
        end

        def network(values)
          compute(data: Network.all, cat: 'category', vals: values)
        end

        private

        def compute(data:, cat:, vals:)
          nbayes = NaiveBayes.new(data, category: cat)
          nbayes.classify(clean_values(vals))
        end

        def clean_values(values)
          values.delete(:algo)
          values
        end
      end
    end
  end
end
