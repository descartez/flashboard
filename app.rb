require 'sinatra'

class App < Sinatra::Base
  get '/' do
    p 'hello'
  end

  get '/edit' do
    p 'edit'
  end
end