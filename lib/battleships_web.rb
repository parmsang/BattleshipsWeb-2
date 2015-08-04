require 'sinatra/base'
require 'battleships'

class BattleshipsWeb < Sinatra::Base
  # force port 3000 for Nitrous
  configure :development do
    set :bind, '0.0.0.0'
    set :port, 3000
  end

  set :views, proc { File.join(root, '..', 'views') }

  get '/' do
    erb :index
  end

  get '/name_set' do
    erb :enter_name
  end

  get '/play' do
    @name=params[:name]
    erb :game
  end

  get '/start_game' do
    $game = Game.new Player, Board
    erb :start_game
  end

  get '/shoot' do
    erb :take_a_shot
  end

  
  # start the server if ruby file executed directly
  run! if app_file == $0

end
