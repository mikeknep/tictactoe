require 'spec_helper'

describe SessionsController do

  let!(:potus) { create(:user, username: 'potus', password: 'usa', password_confirmation: 'usa') }

  describe 'GET #new' do
    it 'renders the new session view' do
      get(:new)
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    it 'creates a new session' do
      post(:create, session: {username: 'potus', password: 'usa'} )
      expect(session[:user_id]).to eq(potus.id)
    end

    it 'redirects to the games index on successful login' do
      post(:create, session: {username: 'potus', password: 'usa'} )
      expect(response).to redirect_to games_path
    end

    it 'renders the new session view on unsuccessful login attempt' do
      post(:create, session: {username: 'potus', password: 'ussr'} )
      expect(response).to redirect_to new_session_path
    end
  end

  describe 'DELETE #destroy' do
    it 'signs out the user' do
      delete(:destroy)
      expect(@current_user).to be_nil
    end

    it 'redirects to the sign in page' do
      delete(:destroy)
      expect(response).to redirect_to new_session_path
    end
  end

end
