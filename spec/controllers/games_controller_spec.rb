require 'spec_helper'

describe GamesController do

  before :each do
    create_user_and_session
    @user_game_1 = create(:game, user: @user)
    @user_game_2 = create(:game, user: @user)

    @robin = create(:user, username: 'robin')
    @robin_game = create(:game, user: @robin)
  end

  describe 'GET #index' do
    it 'assigns all games to @games' do
      get(:index)
      expect(assigns(:games)).to match_array([@user_game_1, @user_game_2])
    end

    it 'renders the index view' do
      get(:index)
      expect(response).to render_template :index
    end
  end


  describe 'GET #show' do
    it 'assigns the correct game to @game' do
      get(:show, id: @user_game_1)
      expect(assigns(:game)).to eq(@user_game_1)
    end

    describe 'checks authorization' do
      it 'renders the show view if the game belongs to the current user' do
        get(:show, id: @user_game_1)
        expect(response).to render_template :show
      end

      it 'redirects to the games index if the game belongs to a different user' do
        get(:show, id: @robin_game)
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

    it 'accepts the computers first move of the game' do
      pending "you can now play first or second, so this needs to change"
      game = create(:game)
      spot = Spot.where(game: game).where(position: 1).first
      expect(spot.player).to eq(1)
    end

    it 'redirects to the newly created game show view' do
      post(:create, game: attributes_for(:game))
      expect(response).to redirect_to game_path(assigns(:game))
    end
  end


  describe 'PATCH #update' do
    it "plays the human's turn" do
      pending "human can play first or second, so this needs to change"
      patch(:update, id: @user_game_1, position: 3)
      @user_game_1.reload
      expect(@user_game_1.gamespot(3).player).to eq(2)
    end

    it "prevents the human from playing an occupied position" do
      expect {
        patch(:update, id: @user_game_1, position: 1)
        }.to_not change(@user_game_1, :spots)
    end

    it "plays the computer's turn" do
      expect {
        patch(:update, id: @user_game_1, position: 3)
      }.to change(@user_game_1.spots.where(player: 1), :count).by(1)
    end

    it "redirects to the game show page" do
      patch(:update, id: @user_game_1, position: 3)
      expect(response).to redirect_to game_path(@user_game_1)
    end
  end


  describe 'DELETE #destroy' do
    it 'destroys the specified game' do
      expect {
        delete(:destroy, id: @user_game_2)
      }.to change(Game, :count).by(-1)
    end

    it 'destroys the spots from the game' do
      expect {
        delete(:destroy, id: @user_game_2)
      }.to change(Spot, :count).by(-9)
    end

    it 'redirects to the game index' do
      delete(:destroy, id: @user_game_2)
      expect(response).to redirect_to games_path
    end
  end

end
