require 'spec_helper'

describe UsersController do

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

    it 'redirects to the root path when user saves' do
      post(:create, user: attributes_for(:user))
      expect(response).to redirect_to root_path
    end

    it 'renders the new template when user does not save' do
      post(:create, user: attributes_for(:user, username: nil))
      expect(response).to render_template :new
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @user = create(:user)
    end

    it 'deletes the requested user' do
      expect {
        delete(:destroy, id: @user)
      }.to change(User, :count).by(-1)
    end

    it 'redirects to the root path' do
      delete(:destroy, id: @user)
      expect(response).to redirect_to root_path
    end
  end

end
