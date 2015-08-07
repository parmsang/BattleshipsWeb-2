require 'spec_helper'

feature 'Starting a new game' do
  feature 'player 1' do
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
    scenario 'Can see own board' do
      game = Game.new Player, Board
      board = game.own_board_view(game.player_1)
      visit '/play'
      click_button 'Start Game'
      expect(page).to have_content board
    end
    scenario 'Can see board showing shot history' do
      game = Game.new Player, Board
      board = game.opponent_board_view(game.player_1)
      visit '/play'
      click_button 'Start Game'
      expect(page).to have_content board
    end
    feature 'Placing ships on board' do
        scenario 'describe ship orientation' do
          game = Game.new Player, Board
          visit '/'
          click_link 'New Game'
          click_button 'Submit'
          click_button 'Start Game'
          board = game.own_board_view(game.player_1)
          find("option[value='submarine']").click
          fill_in "ship_coordinates", with: "A1"
          find("option[value='vertical']").click
          click_button 'Place'
          expect(page).to have_content board
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
  end
  feature 'player 2' do
    scenario 'I am asked to enter my name' do
      visit '/player2'
      click_link 'New Game'
      expect(page).to have_content "What's your name?"
      our_name="Richard"
      fill_in "name", with: our_name
      click_button 'Submit'
      expect(page).to have_content "Hello, #{our_name}"
    end
  end
end
