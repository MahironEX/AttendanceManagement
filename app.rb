require "sinatra"
require "sinatra/base"
require "sinatra/reloader"
require "json"
require "./models"
require "./controllers/users_controller"

class Public < Sinatra::Base
  # HOME 
  get '/' do
    "HelloWorld"
  end
end

class Protect < Sinatra::Base
  use Rack::Auth::Basic, "Protected Area" do |username, password|
    username == 'foo' && password == 'bar'
  end
  # Attendance management
  post '/attendance-record' do
    params =  JSON.parse(request.body.read)
    user = User.find_by(uuid: params["uuid"])
  end
  get "/" do
    "secret page!"
  end
  get "/admin" do
    "admin"
  end
end
