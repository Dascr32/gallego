helpers do

  # Methods used for computing and guessing data

  def compute_style(values)
    styles = LearningStyle.all
    best_guess = {style_id: nil, distance: 100}

    styles.each do |style|
      style_values = [style.ec, style.or, style.ca, style.ea]
      distance = euclidean_distance(values, style_values)

      if distance < best_guess[:distance]
        best_guess[:style_id] = style.id
        best_guess[:distance] = distance
      end
    end
    LearningStyle.find(best_guess[:style_id])
  end

  def euclidean_distance(vector1, vector2)
    sum = 0
    vector1.zip(vector2).each do |subset|
      sum += subset.map(&:to_i).reduce(:-) ** 2
    end
    Math.sqrt(sum)
  end

  # Methods used for rendering and such

  def partial(page, options={})
    erb :"partials/#{page}"
  end

  # Static data used in views

  def learning_styles
    { ec: EC, or: OR, ca: CA, ea: EA }
  end

  EC = ['discerniendo', 'receptivamente', 'sintiendo', 'aceptando', 'intuitivamente', 
    'abstracto', 'orientado al presente', 'aprendo mas de la experiencia', 
    'emotivo'
  ].freeze

  OR = ['ensayando', 'relacionando', 'observando', 'arriesgando', 'productivamente', 
    'observando','reflexivamente', 'aprendo mas de la observacion',
    'reservado'
  ].freeze

  CA = ['involucrandome', 'analiticamente', 'pensando', 'evaluando', 'logicamente', 
    'concreto', 'orientado hacia el futuro','aprendo mas de la conceptualizacion',
    'racional'
  ].freeze

  EA = [ 'practicando', 'imparcialmente', 'haciendo', 'con cautela', 'cuestionando', 
    'activo', 'pragmatico', 'aprendo mas de la experimentacion',
    'abierto'
  ].freeze
end
