
get '/' do
  erb :index
end

get '/styles' do
  erb :styles
end

post '/styles/compute.json' do
  json compute_style([params[:ec], params[:or], params[:ca], params[:ea]])
end

post '/styles/save.json' do
  @style = LearningStyle.create(campus: params[:campus],
                                ec:     params[:ec],
                                or:     params[:or],
                                ca:     params[:ca],
                                ea:     params[:ea],
                                ca_ec:  params[:ca_ec],
                                ea_or:  params[:ea_or],
                                style:  params[:style])
  response = if @style.save
               { code: 201, status: 'created' }
             else
               { code: 400, status: 'error' }
             end

  json response
end
