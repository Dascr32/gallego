# Static data used in views
module Helpers
  module StaticData
    # Points for euclidean distances
    STYLES_POINTS = {
      divergente: 0,
      convergente: 0.5,
      asimilador: 0.10,
      acomodador: 0.15
    }.freeze

    GENDERS_POINTS = {
      m: 1,
      f: 1.5
    }.freeze

    def learning_styles
      opts = YAML.load_file('public/ls_options.yml')
      { ec: opts['ec'], or: opts['or'], ca: opts['ca'], ea: opts['ea'] }
    end
  end
end
