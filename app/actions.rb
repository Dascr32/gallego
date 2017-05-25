get '/' do
  @total_records = total_records
  erb :index
end

get '/about' do
  erb :about
end

get '/styles' do
  @styles = learning_styles
  erb :styles
end

get '/campus' do
  @styles = styles_points.keys
  erb :campus
end

get '/misc' do
  @styles = styles_points.keys
  erb :misc
end

get '/professors' do
  erb :professors
end

get '/networks' do
  erb :networks
end

post '/styles/compute.json' do
  if params[:algo] == 'nbayes'
    json nbayes.style(params)
  else
    json euclidean.style([params[:ec], params[:or], params[:ca], params[:ea]])
  end
end

post '/styles/compute_alt.json' do
  if params[:algo] == 'nbayes'
    json nbayes.style_alt(params)
  else
    json euclidean.style_alt([params[:campus], params[:gender], params[:gpa]])
  end
end

post '/styles/save.json' do
  @style = LearningStyle.create(campus: params[:campus], ec: params[:ec],
                                or: params[:or], ca: params[:ca],
                                ea: params[:ea], ca_ec: params[:ca_ec],
                                ea_or: params[:ea_or], style: params[:style])

  json @style.save ? { code: 201 } : { code: 400 }
end

post '/campus/compute.json' do
  if params[:algo] == 'nbayes'
    json nbayes.campus(params)
  else
    json euclidean.campus([params[:style], params[:gender], params[:gpa]])
  end
end

post '/genders/compute.json' do
  if params[:algo] == 'nbayes'
    json nbayes.gender(params)
  else
    json euclidean.gender([params[:style], params[:campus], params[:gpa]])
  end
end

post '/professors/compute.json' do
  if params[:algo] == 'nbayes'
    json nbayes.professor(params)
  else
    json euclidean.professor([params[:age], params[:gender], params[:c],
                              params[:d], params[:e], params[:f],
                              params[:g], params[:h]])
  end
end

post '/networks/compute.json' do
  if params[:algo] == 'nbayes'
    json nbayes.network(params)
  else
    json euclidean.network([params[:reliability], params[:links],
                            params[:capacity], params[:cost]])
  end
end
