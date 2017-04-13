# Includes methods to render partials
module Partials
  def partial(page)
    erb :"partials/#{page}"
  end
end
