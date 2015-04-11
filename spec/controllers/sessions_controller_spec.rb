require 'rails_helper'

describe SessionsController do

  let(:user) { FactoryGirl.create(:user) }
  let(:logged_in_user) { FactoryGirl.create(:user) }
  let!(:header) { {'X-AUTH-TOKEN' => logged_in_user.session.auth_token} }

  describe '#create' do

    let(:login_credentials) { 
      { username: user.username,
        password: user.password }
    }

    context 'with incorrect credentials' do

      it 'returns 401' do
        post :create, { username: '', password: '' }
        expect(response).to have_http_status(401)        
      end

      it 'does not save the session' do
        auth_token = user.session.auth_token
        post :create, { username: user.username, password: 'wrong' }
        expect(user.session.reload.auth_token).to eq(auth_token) 
      end

    end

    context 'with correct credentials' do
      
      it 'returns 200' do
        post :create, login_credentials
        expect(response).to be_success
      end

      it 'creates new sessions' do
        expect {
          post 'create', login_credentials
        }.to change(Session, :count).by(1)
      end

      it 'updates old sessions' do
        post :create, login_credentials
        expect {
          post 'create', {username: logged_in_user.username,
                          password: logged_in_user.password}
        }.to change(Session, :count).by(0)        
      end

      it 'updates sessions when users are already logged in' do
        auth_token = user.session.auth_token
        post :create, login_credentials         
        expect(user.session.reload.auth_token).to_not eq(auth_token)
      end

    end

  end

  describe '#delete' do

    context 'with the right token' do

      it "returns 200" do
        @request.headers.merge!(header)
        delete :destroy
        expect(response).to be_success 
      end
      
      it "deletes the session" do
        @request.headers.merge!(header)
        expect {        
          delete :destroy
        }.to change(Session, :count).by(-1)
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
        }.to change(Session, :count).by(0)
        
      end

    end

  end

end
