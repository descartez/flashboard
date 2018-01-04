require 'sinatra/base'
require 'yaml'

class App < Sinatra::Base
  before do
    @board_config = YAML::load_file('board_config.yaml')
    @place_name = @board_config['place_name']
    @intro_message = @board_config['place_lead']
    @lead = @board_config['lead']
    @announcements = @board_config['announcements']
  end

  get '/' do
    erb :index
  end

  get '/edit' do
    erb :edit
  end

  post '/update' do
    @board_config['place_name'] = params[:place_name]
    @board_config['place_lead'] = params[:place_lead]
    File.open('board_config.yaml', 'w') {|f| f.write @board_config.to_yaml }

    redirect '/'
  end
end