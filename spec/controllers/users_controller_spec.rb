require 'spec_helper'

describe UsersController do

  let!(:mcfly) { create(:user, username: 'mcfly') }

  before :each do
    session[:user_id] = mcfly.id
  end


  describe 'GET #new' do
    it 'assigns a new user to @user' do
      get(:new)
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'renders the new user view' do
      get(:new)
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    it 'creates a new user' do
      expect {
        post(:create, user: attributes_for(:user))
      }.to change(User, :count).by(1)
    end

    it 'redirects to the games index when user saves' do
      post(:create, user: attributes_for(:user))
      expect(response).to redirect_to games_path
    end

    it 'renders the new template when user does not save' do
      post(:create, user: attributes_for(:user, username: nil))
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    it 'assigns the correct user to @user' do
      get(:show, id: mcfly)
      expect(assigns(:user)).to eq(mcfly)
    end

    it 'renders the user show view for current user' do
      get(:show, id: mcfly)
      expect(response).to render_template :show
    end

    it 'redirects to the games index for unauthorized users' do
      other_user = create(:user, username: 'otherguy')
      get(:show, id: other_user)
      expect(response).to redirect_to games_path
    end
  end

  describe 'GET #edit' do
    it 'assigns the correct user to @user' do
      get(:edit, id: mcfly)
      expect(assigns(:user)).to eq(mcfly)
    end

    it 'renders the edit view for current user' do
      get(:edit, id: mcfly)
      expect(response).to render_template :edit
    end

    it 'redirects to the games index for unauthorized users' do
      other_user = create(:user, username: 'otherguy')
      get(:edit, id: other_user)
      expect(response).to redirect_to games_path
    end
  end

  describe 'PATCH #update' do
    it 'updates the username' do
      expect {
        patch(:update, id: mcfly, user: attributes_for(:user, username: 'docbrown'))
      }.to change(mcfly, :username)
    end

    it 'updates the password when password and password_confirmation match' do
      expect {
        patch(:update, id: mcfly, user: attributes_for(:user, password: 'eastwood', password_confirmation: 'eastwood'))
      }.to change(mcfly, :password_digest)
    end

    it "doesn't update the password when password and password_confirmation don't match" do
      expect {
        patch(:update, id: mcfly, user: attributes_for(:user, password: 'flux', password_confirmation: 'capacitor'))
      }.to_not change(mcfly, :password_digest)
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the requested user' do
      expect {
        delete(:destroy, id: mcfly)
      }.to change(User, :count).by(-1)
    end

    it "deletes the user's games" do
      create(:game, user_id: mcfly.id)
      expect {
        delete(:destroy, id: mcfly)
      }.to change(Game, :count).by(-1)
    end

    it 'redirects to the root path' do
      delete(:destroy, id: mcfly)
      expect(response).to redirect_to root_path
    end
  end

end
