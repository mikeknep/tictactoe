require 'spec_helper'

describe User do
  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  it 'is invalid without a username' do
    expect(build(:user, username: nil)).to_not be_valid
  end

  it 'is invalid without a password' do
    expect(build(:user, password_digest: nil)).to_not be_valid
  end

  describe 'playing games' do
    before :each do
      @walter = create(:user, username: "walter")
      @jesse = create(:user, username: "jesse")

      @ww_game1 = create(:game, user_id: @walter.id)
      @ww_game2 = create(:game, user_id: @walter.id)
      @jp_game1 = create(:game, user_id: @jesse.id)
    end

    it 'has games associated with it' do
      expect(@walter.games).to match_array([@ww_game1, @ww_game2])
    end
  end

end
