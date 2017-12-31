require 'sinatra/base'

class FakeRack < Sinatra::Base
  post '/push' do
    json_response(200, 'push.json')
  end

  put '/config/pushers' do
    json_response(200, 'config_pushers.json')
  end

  get '/stat/go' do
    json_response(200, 'stat_go.json')
  end

  get '/stat/app' do
    json_response(200, 'stat_app.json')
  end

  def json_response(response_code, file_name = nil)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/../fixtures/' + file_name, 'rb').read
  end
end
