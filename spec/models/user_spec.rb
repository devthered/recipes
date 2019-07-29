require 'rails_helper'

RSpec.describe User, type: :model do
  ### class tests
  it { is_expected.to be_mongoid_document }

  ### instance tests
  subject { described_class.new(name: "Dave", email: "cheeseman@example.com", password: "ilovecheese") }

  describe 'Validations' do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }

    it "is not valid without a password" do
      subject.password = nil
      expect(subject).to_not be_valid
    end

    it "is not valid with a too-long name" do
      subject.name = 'a' * 51
      expect(subject).to_not be_valid
    end
    
    it "is not valid with an invalid email" do
      subject.email = 'bademail.mail'
      expect(subject).to_not be_valid
    end
    
    it "is not valid with a too-short password" do
      subject.password = 'hi'
      expect(subject).to_not be_valid
    end
  end

  describe 'Associations' do
    it { should have_many(:recipes) }
  end

  describe '.authenticated?' do
    it 'returns true on matching token' do
      token = User.new_token
      subject.remember_digest = User.digest(token)
      expect(subject.authenticated?(:remember, token)).to be true
    end

    it 'returns false on non-matching token' do
      subject.remember_digest = User.digest(User.new_token)
      expect(subject.authenticated?(:remember, User.new_token)).to be false
    end
  end

  describe '.remember' do
    it 'generates remember_token' do
      expect(subject.remember_token).to be nil
      subject.remember
      expect(subject.remember_token).to_not be nil
    end

    it 'generates remember_digest' do
      expect(subject.remember_digest).to be nil
      subject.remember
      expect(subject.remember_digest).to_not be nil
    end

    it 'token and digest match' do
      subject.remember
      expect(BCrypt::Password.new(subject.remember_digest).is_password?(subject.remember_token)).to be true
    end
  end

  describe '.forget' do
    it 'clears remember_digest' do
      subject.remember_digest = 'something'
      subject.forget
      expect(subject.remember_digest).to be nil
    end
  end
  
end