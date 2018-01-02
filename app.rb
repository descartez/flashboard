require 'sinatra/base'
require 'yaml'

class App < Sinatra::Base
  before do
    board_config = YAML::load_file('board_config.yaml')
    @place_name = board_config['place_name']
    @intro_message = board_config['intro_message']
    @lead = board_config['lead']
    @announcements = board_config['announcements']
  end

  get '/' do
    erb :index
  end

  get '/edit' do
    @slides = [1,2,3]
    @announcements = [1,2,3]
    erb :edit
  end
end