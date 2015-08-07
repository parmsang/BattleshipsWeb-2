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
    $players ||= []

    #redirect '/full_game' if full_game?
    set_player_session
    $game.send(current_player)

    erb :start_game
  end

  def current_player
    session[:player]
  end

  def full_game?
    $players.count == 2
  end

  def set_player_session
    if $players.empty?
      session[:player] = :player_1
      $players << :player_1
    else
      session[:player] = :player_2
      $players << :player_2
    end
  end

  post '/start_game' do
    if params[:fire_coordinates]
      @fire_coordinates = params[:fire_coordinates]
    else
      $game.send(session[:player]).place_ship Ship.send(params[:ship_type]), params[:ship_coordinates].to_sym, params[:ship_direction]
    end
    erb :start_game
  end

  get "/" do
    switch_players
    "It's #{session["current_player"]}'s turn"
    p session
  end

  def switch_players
    @current_player = session["current_player"].freeze
    if @current_player == "Player 1"
      session["current_player"] = "Player 2"
    elsif @current_player == "Player 2"
      session["current_player"] = "Player1 "
    else
      session["current_player"] = "Player 1"
    end
  end

  get '/player2_place' do
    erb :place
  end

  post '/player2_place' do
    $game.player_2.place_ship Ship.send(params[:ship_type]), params[:ship_coordinates].to_sym, params[:ship_direction]
    redirect '/start_game'
  end

    # start the server if ruby file executed directly
  run! if app_file == $0

end
