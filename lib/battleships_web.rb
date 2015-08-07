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
    erb :player1_enter_name
  end

  get '/play' do
    @name = params[:name]
    erb :hello_player1
  end

  get '/start_game' do
    $game = Game.new Player, Board
    erb :start_game
  end

  post '/start_game' do
    if params[:fire_coordinates]
      @fire_coordinates = params[:fire_coordinates]
    else
      $game.player_1.place_ship Ship.send(params[:ship_type]), params[:ship_coordinates].to_sym, params[:ship_direction]
    end
    erb :start_game
  end

  get '/player2_place' do
    erb :place
  end

  post '/player2_place' do
    $game.player_2.place_ship Ship.send(params[:ship_type]), params[:ship_coordinates].to_sym, params[:ship_direction]
    redirect '/start_game'
  end

  # PLAYER 2 code!

  get '/player2' do
    erb :index2
  end

  get '/name_set2' do
    erb :player2_enter_name
  end

  get '/play' do
    @name = params[:name]
    erb :hello_player2
  end

  get '/start_game' do
    $game = Game.new Player, Board
    erb :start_game2
  end

  # start the server if ruby file executed directly
  run! if app_file == $0

end
