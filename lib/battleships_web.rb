require 'sinatra/base'
require 'battleships'

class BattleshipsWeb < Sinatra::Base
  # force port 3000 for Nitrous
  configure :development do
    set :bind, '0.0.0.0'
    set :port, 3000
  end

  enable :sessions

  set :views, proc { File.join(root, '..', 'views') }

  get '/' do
    erb :index
  end

  get '/name_set' do
    erb :enter_name
  end

  get '/play' do
    @name = params[:name]
    erb :hello
  end

  get '/start_game' do
    $game = Game.new Player, Board
    $players ||= []

    redirect '/full_game' if full_game?
    set_player_session
    $game.send(current_player1)
    erb :start_game
  end

  def current_player1
    session[:current_player]
  end

  def full_game?
    $players.count == 2
  end

  get '/full_game' do
    
    erb :lobby
  end

  def set_player_session
    if $players.empty?
      session[:current_player] = :player_1
      $players << :player_1
    else
      session[:current_player] = :player_2
      $players << :player_2
    end
  end

  post '/start_game' do
    if params[:fire_coordinates]
      @fire_coordinates = params[:fire_coordinates]
      switch_players
    else
      $game.send(session[:current_player]).place_ship Ship.send(params[:ship_type]), params[:ship_coordinates].to_sym, params[:ship_direction]
    end

    erb :start_game
  end

  def switch_players
    @current_player = session[:current_player].freeze
      if @current_player == :player_1
      session[:current_player] = :player_2
    elsif @current_player == :player_2
      session[:current_player] = :player_1
      else
      session[:current_player] = :player_1
      end
    end

  # start the server if ruby file executed directly
  run! if app_file == $0

end
