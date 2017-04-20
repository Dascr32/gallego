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
      m: 0,
      f: 0.5
    }.freeze

    CAMPUS_POINTS = {
      paraiso: 0,
      turrialba: 0.5
    }.freeze

    def learning_styles
      opts = YAML.load_file('public/ls_options.yml')
      { ec: opts['ec'], or: opts['or'], ca: opts['ca'], ea: opts['ea'] }
    end

    def styles_points
      STYLES_POINTS
    end

    def genders_points
      GENDERS_POINTS
    end
  end
end
