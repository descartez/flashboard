require 'sinatra/base'
require 'erb'

class App < Sinatra::Base
  get '/' do
    erb :index
  end

  get '/edit' do
    erb :edit
  end
end