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

post '/styles/compute.json' do
  json euclidean.style([params[:ec], params[:or], params[:ca], params[:ea]])
end

post '/styles/compute_alt.json' do
  json euclidean.style_alt([params[:campus], params[:gender], params[:gpa]])
end

post '/styles/save.json' do
  @style = LearningStyle.create(campus: params[:campus], ec: params[:ec],
                                or: params[:or], ca: params[:ca],
                                ea: params[:ea], ca_ec: params[:ca_ec],
                                ea_or: params[:ea_or], style: params[:style])

  json @style.save ? { code: 201 } : { code: 400 }
end

get '/campus' do
  @styles = styles_points.keys
  erb :campus
end

post '/campus/compute.json' do
  json euclidean.campus([params[:style], params[:gender], params[:gpa]])
end

get '/misc' do
  @styles = styles_points.keys
  erb :misc
end

post '/genders/compute.json' do
  json euclidean.gender([params[:style], params[:campus], params[:gpa]])
end

get '/professors' do
  erb :professors
end

post '/professors/compute.json' do
  json euclidean.professor([params[:age], params[:gender], params[:c],
                            params[:d], params[:e], params[:f],
                            params[:g], params[:h]])
end

get '/networks' do
  erb :networks
end

post '/networks/compute.json' do
  json euclidean.network([params[:reliability], params[:links],
                          params[:capacity], params[:cost]])
end
