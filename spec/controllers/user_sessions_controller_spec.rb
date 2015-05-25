require 'rails_helper'

describe UserSessionsController do

  let(:user) { FactoryGirl.create(:user, :with_bucket) }
  let(:logged_in_user) { FactoryGirl.create(:user, :logged_in) }
  let!(:header) { 
    {'X-AUTH-TOKEN' => logged_in_user.user_session.auth_token} 
  }

  describe '#create' do

    let(:login_credentials) { 
      { user: {
        username: user.username,
        password: user.password }
      }
    }

    context 'with incorrect credentials' do

      it 'returns 401' do
        post :create, { user: { username: '', password: '' } }
        expect(response).to have_http_status(401)        
      end

      it 'does not save the session' do
        auth_token = logged_in_user.user_session.auth_token
        post :create, { user: { username: logged_in_user.username, password: 'wrong' } }
        expect(logged_in_user.user_session.reload.auth_token).to eq(auth_token) 
      end

    end

    context 'with correct credentials' do

      it 'returns 200' do
        post :create, login_credentials
        expect(response).to be_success
      end

      it "returns 400 with invalid params" do
        post :create, {}
        expect(response).to have_http_status(400)
      end

    end

  end

  describe '#delete' do

    context 'with the right token' do

      it "returns 204" do
        @request.headers.merge!(header)
        delete :destroy
        expect(response).to have_http_status(204)
      end
      
      it "deletes the session" do
        @request.headers.merge!(header)
        expect {        
          delete :destroy
        }.to change(UserSession, :count).by(-1)
      end 

    end

    context 'with incorrect token' do
      before {
        @request.headers.merge!({'X-AUTH-TOKEN' => 'wrong'})
      }

      it "returns 401" do
        delete :destroy 
        expect(response).to have_http_status(401)
      end

      it "does not delete the session" do
        expect{
         delete :destroy
        }.to change(UserSession, :count).by(0)
        
      end

    end

  end

end
