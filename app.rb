require 'sinatra'

class Sharp < Sinatra::Application
  get '/' do
    'Hello world!'
  end
end
