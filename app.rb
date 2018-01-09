require 'sinatra/base'
require 'yaml'
require 'JSON'

class App < Sinatra::Base
  before do
    file = File.read('public/board_config.json')
    @board_config = JSON.parse(file)
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

  get '/upload' do
    @images = []
    Dir.open './public/images/' do |files|
      files.each_with_index do |f,index|
        if index > 1
          @images << f
        end
      end
    end
    erb :upload
  end

  post '/update' do
    unless params[:place_name].strip.empty?
      @board_config['place_name'] = params[:place_name].to_s
    end
    unless params[:intro_message].strip.empty?
      @board_config['intro_message'] = params[:intro_message].to_s
    end

    @board_config['announcements'] = params[:announcements].split("-").reject {|element| element.empty? }
    @board_config['announcements'].each do |announcement|
      announcement.strip!
      announcement.sub(/\n/,"")
    end

    File.open('public/board_config.json', 'w') {|f| f.write @board_config.to_json }

    redirect '/'
  end
end