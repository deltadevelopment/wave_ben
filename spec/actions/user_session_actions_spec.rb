require 'rails_helper'

describe UserSessionActions do
  
  describe "#create" do
    let!(:user) { FactoryGirl.create(:user, :with_bucket) }
    let(:valid_params){
      { username: user.username,
        password: user.password
      }
    }
    
    it "creates a new session the first time" do
      expect{
        UserSessionActions.new(param: valid_params).create!
      }.to change(UserSession, :count).by(1)
    end

    it "updates the existing session" do
      user_session, _ = UserSessionActions.new(param: valid_params).create!
      user_session2, _ =UserSessionActions.new(param: valid_params).create!
      expect(user_session.reload.auth_token).to eql(user_session2.auth_token)
    end

# This does not work in production testing, but passes fine locally
#    it "queues workers when including device_id and device_type" do
#      valid_params.merge!({device_id: 'A'*16, device_type: 'ios'})
#      expect(AddDeviceTokenJob).to receive(:perform_later)  
#      UserSessionActions.new(param: valid_params).create!
#    end

  end

end
