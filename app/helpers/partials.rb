# Includes methods to render partials
module Helpers
  module Partials
    def partial(page)
      erb :"partials/#{page}"
    end
  end
end
