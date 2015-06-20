require 'rails_helper'

describe User do

  let(:user) { FactoryGirl.build(:user) }

  it { should have_one(:user_session).dependent(:destroy) }
  it { should have_many(:buckets).dependent(:destroy) }
  it { should have_many(:drops).dependent(:destroy) }
  it { should have_many(:tags).dependent(:destroy) }
  it { should have_many(:subscribers).dependent(:destroy) }
  it { should have_many(:subscribees).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:ripples).dependent(:destroy) }

  describe "test the tests" do
    it "initializes a valid user" do
      expect(user).to be_valid
    end
  end

  describe "username format" do
    
    it "should not contain spaces" do
      user.username = "juic es"
      expect(user).not_to be_valid
    end

    it "allows underscores" do
      user.username = "wave_rider"
      expect(user).to be_valid
    end

    it "should be less than 16 characters" do
      16.times { user.username << "a" } 
      expect(user).not_to be_valid
    end

    it "should be more than 1 character" do
      user.username = "" 
      expect(user).to_not be_valid 
    end

    it "checks for uniqueness" do
      existing_user = FactoryGirl.create(:user) 
      user.username = existing_user.username
      expect(user).not_to be_valid
    end

    ['Incor rect', 'spe$ial', ' ', 'no.dots'].each do |username|
      it "does not allow username '#{username}'" do
        user.username = username 
        expect(user).not_to be_valid
      end
    end

  end  

  describe "display_name format" do
    
    it "should only contain alpha numeric characters" do
      user.display_name = "$ucks"
      expect(user).not_to be_valid
    end
    
    it "should be more than 1 character" do
      user.display_name = ""
      expect(user).not_to be_valid
    end

    it "should be less than 25 characters" do
      26.times { user.username << "a" }
      expect(user).not_to be_valid
    end

    it "does not allow leading whitespace" do
      user.display_name = " my name"
      expect(user).not_to be_valid
    end

  end
  
  describe "email format" do
    
    it "should only allow valid e-mail adresses" do
      user.email = "jfk@.juices.com"
      expect(user).not_to be_valid
    end

    it "doesn't allow users to register with the same email" do
      existing_user = FactoryGirl.create(:user)
      user.email = existing_user.email
      expect(user).not_to be_valid
    end

  end

  describe "phone number format" do
    
    it "should only contain digits" do
      user.phone_number = "abcdefghij"
      expect(user).not_to be_valid
    end

    it "doesn't allow users to regsiter with the same phone number" do
      existing_user = FactoryGirl.create(:user)
      user.phone_number = existing_user.phone_number
      expect(user).not_to be_valid
    end

  end

  describe "password format" do

    it "can't be blank" do
      user.password = ""
      expect(user).not_to be_valid
    end

    it "is 6 or more characters" do
      user.password = "A" * 5
      expect(user).not_to be_valid
    end
    
    it "is less than 20 characters" do
      user.password = "A" * 21
      expect(user).not_to be_valid
    end

    it "stores encrypted password and salt in the database" do
      existing_user = FactoryGirl.create(:user)
      expect(existing_user.password_hash).not_to be_nil
      expect(existing_user.password_salt).not_to be_nil
    end

  end

end
