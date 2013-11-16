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

    it 'redirects to the newly created game show view' do
      post(:create, game: attributes_for(:game))
      expect(response).to redirect_to game_path(assigns(:game))
    end
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
