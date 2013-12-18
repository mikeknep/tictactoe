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

end
