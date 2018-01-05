require 'sinatra/base'
require 'yaml'

class App < Sinatra::Base
  before do
    @board_config = YAML::load_file('board_config.yaml')
    @place_name = @board_config['place_name']
    @intro_message = @board_config['intro_message']
    @announcements = @board_config['announcements']
  end

  get '/' do
    erb :index
  end

  get '/edit' do
    erb :edit
  end

  post '/update' do
    p params
    @board_config['place_name'] = params[:place_name]
    @board_config['intro_message'] = params[:intro_message]
    @board_config['announcements'] = params[:announcements].split("-").reject {|element| element.empty? }
    @board_config['announcements'].each do |announcement|
      announcement.strip!
      announcement.sub(/\n/,"")
    end

    File.open('board_config.yaml', 'w') {|f| f.write @board_config.to_yaml }

    redirect '/'
  end
end