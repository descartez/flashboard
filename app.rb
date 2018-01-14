require 'sinatra/base'
require 'JSON'
require 'socket'


class App < Sinatra::Base
  set :bind, '0.0.0.0'
  set :port, 9393

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

  #----------------------------------
  # INDEX: homepage for dashboard
  #----------------------------------

  get '/' do
    erb :index
  end

  #----------------------------------
  # SETUP: for when it first starts up
  #----------------------------------

  get '/setup' do
    if !!@board_config['password_string']
      erb :new_password
    else
      erb :setup
    end
  end

  post '/setup' do
    if params['password'] == params['password_confirmation']
      @board_config['password_string'] = params['password']

      File.open('public/board_config.json', 'w') {|f| f.write @board_config.to_json }

      redirect '/edit'
    else
      redirect '/setup'
    end
  end

  get '/auth' do
    if !@board_config['password_string']
      redirect '/setup'
    else
      'auth'
    end
  end

  #----------------------------------
  # EDIT: for making changes
  #----------------------------------

  get '/edit' do
    erb :edit
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

    File.open('public/board_config.json', 'w') {|f| f.write @board_config.to_json }

    redirect '/edit'
  end

  #----------------------------------
  # UPLOAD: for uploading files
  #----------------------------------

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

    redirect '/upload'
  end



end