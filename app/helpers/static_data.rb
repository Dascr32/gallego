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

    PROFESSORS_POINTS = {
      f: 0,
      m: 0.5,
      na: 0.10,
      b: 0.15,
      i: 0.20,
      a: 0.25,
      dm: 0.30,
      nd: 0.35,
      l: 0.45,
      h: 0.55,
      n: 0.60,
      s: 0.65,
      o: 0.70
    }.freeze

    NETWORKS_POINTS = {
      low: 0,
      medium: 0.5,
      high: 0.10
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

    def total_records
      sum = LearningStyle.count(:all)
      sum += Student.count(:all)
      sum += Professor.count(:all)
      sum + Network.count(:all)
    end
  end
end
