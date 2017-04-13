# Static data used in views
module StaticData
  def learning_styles
    opts = YAML.load_file('public/ls_options.yml')
    { ec: opts['ec'], or: opts['or'], ca: opts['ca'], ea: opts['ea'] }
  end
end
