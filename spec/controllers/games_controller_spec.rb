require 'spec_helper'

describe GamesController do

  describe 'GET #index' do
    it 'assigns all games to @games' do
      game_1 = create(:game)
      game_2 = create(:game)
      get(:index)
      expect(assigns(:games)).to match_array([game_1, game_2])
    end

    it 'renders the index view' do
      get(:index)
      expect(response).to render_template :index
    end
  end


  describe 'GET #show' do
    before :each do
      @game = create(:game)
    end

    it 'assigns the correct game to @game' do
      get(:show, id: @game)
      expect(assigns(:game)).to eq(@game)
    end

    it 'renders the show view' do
      get(:show, id: @game)
      expect(response).to render_template :show
    end
  end


  describe 'POST #create' do
    it 'creates a new game' do
      expect {
        post(:create, game: attributes_for(:game))
      }.to change(Game, :count).by(1)
    end

    it 'builds the game board' do
      expect {
        post(:create, game: attributes_for(:game))
      }.to change(Spot, :count).by(9)
    end

    it 'accepts the computers first move of the game' do
      game = create(:game)
      spot = Spot.where(game: game).where(position: 1).first
      expect(spot.player).to eq('X')
    end

    it 'redirects to the newly created game show view' do
      post(:create, game: attributes_for(:game))
      expect(response).to redirect_to game_path(assigns(:game))
    end
  end


  describe 'PATCH #human_turn_1' do
    before :each do
      @game = create(:game)
    end

    context 'defines the game as a corner-type game' do
      it 'top-right' do
        patch(:human_turn_1, game_id: @game.id, position: 3)
        @game.reload
        expect(@game.gametype).to eq('corner')
      end

      it 'bottom-left' do
        patch(:human_turn_1, game_id: @game.id, position: 7)
        @game.reload
        expect(@game.gametype).to eq('corner')
      end

      it 'bottom-right' do
        patch(:human_turn_1, game_id: @game.id, position: 9)
        @game.reload
        expect(@game.gametype).to eq('corner')
      end
    end

    context 'defines the game as a peninsula-type game' do
      it 'top-middle' do
        patch(:human_turn_1, game_id: @game.id, position: 2)
        @game.reload
        expect(@game.gametype).to eq('peninsula')
      end

      it 'middle-left' do
        patch(:human_turn_1, game_id: @game.id, position: 4)
        @game.reload
        expect(@game.gametype).to eq('peninsula')
      end

      it 'middle-right' do
        patch(:human_turn_1, game_id: @game.id, position: 6)
        @game.reload
        expect(@game.gametype).to eq('peninsula')
      end

      it 'bottom-middle' do
        patch(:human_turn_1, game_id: @game.id, position: 8)
        @game.reload
        expect(@game.gametype).to eq('peninsula')
      end
    end

    context 'defines the game as a middle-type game' do
      it 'middle' do
        patch(:human_turn_1, game_id: @game.id, position: 5)
        @game.reload
        expect(@game.gametype).to eq('middle')
      end
    end

    it 'increases the number of human turns played so far in the game' do
      expect {
        patch(:human_turn_1, game_id: @game.id, position: 3)
        @game.reload
        }.to change(@game, :human_turns).by(1)
    end

    it 'sets the human players spot to player O' do
      patch(:human_turn_1, game_id: @game.id, position: 3)
      @game.reload
      expect(@game.spots.where(position: 3).first.player).to eq('O')
    end

    it 'sets the computers second move as player X' do
      patch(:human_turn_1, game_id: @game.id, position: 5) # FIXME: currently defining position 5 because only have logic for middle games. eventually, change to position: rand(1..9)
      @game.reload
      expect(@game.spots.where(player: 'X').count).to eq(2)
    end

    it 'redirects to the game show view' do
      patch(:human_turn_1, game_id: @game.id, position: rand(1..9))
      expect(response).to redirect_to(game_path(assigns(:game)))
    end
  end


  describe 'PATCH #human_turn_2' do
    before :each do
      @game = create(:game)
    end

    it 'increases the number of human turns played so far in the game' do
      expect {
        patch(:human_turn_2, game_id: @game.id, position: rand(1..9))
        @game.reload
        }.to change(@game, :human_turns).by(1)
    end

    it 'sets the human players spot to player O' do
      patch(:human_turn_2, game_id: @game.id, position: 6)
      @game.reload
      expect(@game.spots.where(position: 6).first.player).to eq('O')
    end

    it 'redirects to the game show view' do
      patch(:human_turn_2, game_id: @game.id, position: rand(1..9))
      expect(response).to redirect_to(game_path(assigns(:game)))
    end
  end


  describe 'PATCH #human_turn_3' do
    before :each do
      @game = create(:game)
    end

    it 'increases the number of human turns played so far in the game' do
      expect {
        patch(:human_turn_3, game_id: @game.id, position: rand(6..8))
        @game.reload
        }.to change(@game, :human_turns).by(1)
    end

    it 'sets the human players spot to player O' do
      patch(:human_turn_3, game_id: @game.id, position: 6)
      @game.reload
      expect(@game.spots.where(position: 6).first.player).to eq('O')
    end

    it 'redirects to the game show view' do
      patch(:human_turn_3, game_id: @game.id, position: rand(6..8))
      expect(response).to redirect_to(game_path(assigns(:game)))
    end
  end


  describe 'PATCH #human_turn_4' do

  end


  describe 'DELETE #destroy' do
    before :each do
      @game = create(:game)
    end

    it 'destroys the specified game' do
      expect {
        delete(:destroy, id: @game)
      }.to change(Game, :count).by(-1)
    end

    it 'destroys the spots from the game' do
      expect {
        delete(:destroy, id: @game)
      }.to change(Spot, :count).by(-9)
    end

    it 'redirects to the game index' do
      delete(:destroy, id: @game)
      expect(response).to redirect_to games_path
    end
  end

end
