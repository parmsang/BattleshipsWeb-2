require 'spec_helper'

feature 'Starting a new game' do
  scenario 'I am asked to enter my name' do
    visit '/'
    click_link 'New Game'
    expect(page).to have_content "What's your name?"
    our_name="Richard"
    fill_in "name", with: our_name
    click_button 'Submit'
    expect(page).to have_content "Hello, #{our_name}"
  end
  scenario 'Gives default name if none submitted' do
    visit '/'
    click_link 'New Game'
    click_button 'Submit'
    expect(page).to have_content "Hello, Player 1"
  end
  scenario 'Starts a new game' do
    game = Game.new Player, Board
    board = game.own_board_view(game.player_1)
    visit '/play'
    click_button 'Start Game'
    expect(page).to have_content board
  end
  scenario 'Starts a new game' do
    game = Game.new Player, Board
    board = game.opponent_board_view(game.player_1)
    visit '/play'
    click_button 'Start Game'
    expect(page).to have_content board
  end
  # scenario 'Puts ships on own board' do
  #   visit '/start_game'
  #   expect(page).to have_content "Please add ships to your board."
  # end
  scenario 'Places ships on own board' do
    visit '/start_game'
    click_button 'Place'
    expect(page).to have_content "You have placed your first ship"
  end
end


feature 'Shooting at opponent board' do
  scenario 'I am asked to enter coordinates' do
    visit '/start_game'
    expect(page).to have_content "Enter coordinates to fire"
  end

  scenario 'I can enter coordinates' do
    visit '/'
    click_link 'New Game'
    click_button 'Submit'
    click_button 'Start Game'
    coordinates = "A1"
    fill_in "fire_coordinates", with: coordinates
    click_button 'Fire'
    expect(page).to have_content "miss"
  end
end
