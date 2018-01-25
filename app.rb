require 'rubygems'

# sinatra and database
require 'sinatra/base'
require 'sinatra/activerecord'
require 'sqlite3'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require './models/image'


require 'json'
require 'socket'
require 'redcarpet'


CarrierWave.configure do |config|
  config.root = File.dirname(__FILE__) + "/public"
end

class App < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  set :bind, '0.0.0.0'
  set :port, 9393

  def markdown(text)
        options = {
      filter_html:     true,
      hard_wrap:       true,
      link_attributes: { rel: 'nofollow', target: "_blank" },
      space_after_headers: true,
      fenced_code_blocks: true
    }

    extensions = {
      autolink:           true,
      superscript:        true,
      disable_indented_code_blocks: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text)
  end

  def write_to_config
    File.open('public/board_config.json', 'w') {|f| f.write @board_config.to_json }
  end

  def to_boolean(obj)
    if obj == "true"
      true
    else
      false
    end
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
    @local_video = to_boolean(@board_config['local_video'])
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
      img = Image.new
      img.file = params[:file]
      img.visible = true

      #Save
      img.save!

    redirect '/upload'
  end

  post '/upload_logo' do
    extension = params[:file][:filename][/[^.]+$/]
    file = params[:file][:tempfile]

    File.open("./public/uploads/images/logo", 'wb') do |f|
      f.write(file.read)
    end

    @board_config['reload'] = "true"

    write_to_config

    redirect '/upload'
  end

  post '/upload_video' do
    extension = params[:file][:filename][/[^.]+$/]
    file = params[:file][:tempfile]

    File.open("./public/uploads/videos/video", 'wb') do |f|
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

    if params[:video_source] == "youtube"
      @board_config['local_video'] = "false"
    elsif params[:video_source] == "local"
      @board_config['local_video'] = "true"
    end

    @board_config['announcements'] = params[:announcements]

    @board_config['reload'] = "true"

    write_to_config

    redirect '/edit'
  end
end