module Helpers
  module Routes
    def euclidean
      Helpers::Euclidean::Compute
    end

    def nbayes
      Helpers::NBayes::Compute
    end
  end
end
