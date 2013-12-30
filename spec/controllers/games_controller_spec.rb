require 'spec_helper'

describe GamesController do

  let!(:mcfly) { create(:user, username: 'mcfly') }
  let!(:mcfly_game_1) { create(:game, user: mcfly) }
  let!(:mcfly_game_2) { create(:game, user: mcfly) }

  let!(:biff) { create(:user, username: 'biff') }
  let!(:biff_game) { create(:game, user: biff) }

  before :each do
    session[:user_id] = mcfly.id
  end


  describe 'GET #index' do
    it "assigns all the current user's games to @games" do
      get(:index)
      expect(assigns(:games)).to match_array([mcfly_game_1, mcfly_game_2])
    end

    it 'renders the index view' do
      get(:index)
      expect(response).to render_template :index
    end
  end


  describe 'GET #show' do
    it 'assigns the correct game to @game' do
      get(:show, id: mcfly_game_1)
      expect(assigns(:game)).to eq(mcfly_game_1)
    end

    describe 'checks authorization' do
      it 'renders the show view if the game belongs to the current user' do
        get(:show, id: mcfly_game_1)
        expect(response).to render_template :show
      end

      it 'redirects to the games index if the game belongs to a different user' do
        get(:show, id: biff_game)
        expect(response).to redirect_to games_path
      end
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

    it 'does not play the computers first turn if human is playing first' do
      expect {
        post(:create, game: attributes_for(:game), commit: "Play as X")
      }.to_not change(Spot.where(player: 1), :count)
    end

    it 'plays the computers first turn if human is playing second' do
      expect {
        post(:create, game: attributes_for(:game), commit: "Play as O")
        }.to change(Spot.where(player: 1), :count).by(1)
    end

    it 'redirects to the newly created game show view' do
      post(:create, game: attributes_for(:game))
      expect(response).to redirect_to game_path(assigns(:game))
    end
  end


  describe 'PATCH #update' do
    context 'when the human is playing first (as X)' do
      it "plays the human's turn" do
        patch(:update, id: mcfly_game_1, position: 3)
        mcfly_game_1.reload
        expect(mcfly_game_1.gamespot(3).player).to eq(1)
      end

      it "prevents the human from playing an occupied position" do
        mcfly_game_1.gamespot(4).update_attribute(:player, 2)
        expect {
          patch(:update, id: mcfly_game_1, position: 4)
          }.to_not change(mcfly_game_1.gamespot(4), :player)
      end

      it "plays the computer's turn" do
        expect {
          patch(:update, id: mcfly_game_1, position: 3)
        }.to change(mcfly_game_1.spots.where(player: 2), :count).by(1)
      end
    end

    context 'when the human is playing second (as O)' do
      before :each do
        mcfly_game_2.computers_first_turn
      end

      it "plays the human's turn" do
        patch(:update, id: mcfly_game_2, position: 3)
        mcfly_game_2.reload
        expect(mcfly_game_2.gamespot(3).player).to eq(2)
      end

      it "prevents the human from playing an occupied position" do
        mcfly_game_2.gamespot(6).update_attribute(:player, 1)
        expect {
          patch(:update, id: mcfly_game_2, position: 6)
        }.to_not change(mcfly_game_2.gamespot(6), :player)
      end

      it "plays the computer's turn" do
        expect {
          patch(:update, id: mcfly_game_2, position: 7)
        }.to change(mcfly_game_2.spots.where(player: 1), :count).by(1)
      end
    end

    it "redirects to the game show page" do
      patch(:update, id: mcfly_game_1, position: 3)
      expect(response).to redirect_to game_path(mcfly_game_1)
    end
  end


  describe 'DELETE #destroy' do
    it 'destroys the specified game' do
      expect {
        delete(:destroy, id: mcfly_game_2)
      }.to change(Game, :count).by(-1)
    end

    it 'destroys the spots from the game' do
      expect {
        delete(:destroy, id: mcfly_game_2)
      }.to change(Spot, :count).by(-9)
    end

    it 'redirects to the game index' do
      delete(:destroy, id: mcfly_game_2)
      expect(response).to redirect_to games_path
    end
  end

end
