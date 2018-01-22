require 'rubygems'
require 'sinatra/base'
require 'json'
require 'socket'


class App < Sinatra::Base
  set :bind, '0.0.0.0'
  set :port, 9393

  def write_to_config
    File.open('public/board_config.json', 'w') {|f| f.write @board_config.to_json }
  end

  before do
    Socket.ip_address_list.each do |ip|
      if ip.ip_address.match(/\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/)
        @ip_address = "#{ip.ip_address}:9393"
      end
    end

    file = File.read('public/board_config.json')
    @board_config = JSON.parse(file)
    @place_name = @board_config['place_name']
    @intro_message_header = @board_config['intro_message_header']
    @intro_message_lead = @board_config['intro_message_lead']
    @announcements = @board_config['announcements']
  end

  get '/' do
    @board_config['reload'] = "false"
    write_to_config
    erb :index
  end

  get '/edit' do
    erb :edit
  end

  get '/upload' do
    erb :upload
  end

  post '/upload' do
    @filename = params[:file][:filename]
    file = params[:file][:tempfile]

    File.open("./public/images/#{@filename}", 'wb') do |f|
      f.write(file.read)
    end

    redirect '/upload'
  end

  post '/upload_logo' do
    extension = params[:file][:filename][/[^.]+$/]
    file = params[:file][:tempfile]

    File.open("./public/images/logo", 'wb') do |f|
      f.write(file.read)
    end

    @board_config['reload'] = "true"

    write_to_config

    redirect '/upload'
  end

  post '/update' do
    unless params[:place_name].strip.empty?
      @board_config['place_name'] = params[:place_name].to_s
    end
    unless params[:intro_message_header].strip.empty?
      @board_config['intro_message_header'] = params[:intro_message_header].to_s
    end
    unless params[:intro_message_lead].strip.empty?
      @board_config['intro_message_lead'] = params[:intro_message_lead].to_s
    end

    unless params[:youtube_id].strip.empty?
      @board_config['youtube_id'] = params[:youtube_id][/(?:https?:\/{2})?(?:w{3}\.)?youtu(?:be)?\.(?:com|be)(?:\/watch\?v=|\/)([^\s&]+)/, 1].to_s
    end

    @board_config['announcements'] = params[:announcements].split("-").reject {|element| element.empty? }
    @board_config['announcements'].each do |announcement|
      announcement.strip!
      announcement.sub(/\n/,"")
    end

    @board_config['reload'] = "true"

    write_to_config

    redirect '/edit'
  end
end