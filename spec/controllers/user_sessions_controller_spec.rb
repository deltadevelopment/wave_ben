require 'rails_helper'

describe UserSessionsController do

  let(:user) { FactoryGirl.create(:user) }
  let(:logged_in_user) { FactoryGirl.create(:user, :logged_in) }
  let!(:liu_device_id) { FactoryGirl.create(:user, :logged_in_with_device_id) }
  let!(:header) { {'X-AUTH-TOKEN' => logged_in_user.user_session.auth_token} }

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
        auth_token = logged_in_user.user_session.auth_token
        post :create, { username: logged_in_user.username, password: 'wrong' }
        expect(logged_in_user.user_session.reload.auth_token).to eq(auth_token) 
      end

    end

    context 'with correct credentials' do

      ENV['AWS_SNS_IOS_ARN'] = 'A'*30

      let(:liu_login_credentials) { 
        { username: logged_in_user.username,
          password: logged_in_user.password }
      }

      let(:liu_device_id_creds) {
        { username: liu_device_id.username,
          password: liu_device_id.password,
          device_id: liu_device_id.user_session.device_id,
          device_type: liu_device_id.user_session.device_type }
      }
      
      it 'returns 200' do
        post :create, login_credentials
        expect(response).to be_success
      end

      it 'creates new sessions' do
        expect {
          post :create, login_credentials
        }.to change(UserSession, :count).by(1)
      end

      it 'updates old sessions' do
          post :create, liu_login_credentials
                       
        expect {
          post :create, liu_login_credentials
        }.to change(UserSession, :count).by(0)        
      end

      context 'with device_id and device_type set' do

        it 'updates sessions when users are already logged in' do
          auth_token = liu_device_id.user_session.auth_token
          post :create, liu_device_id_creds
          expect(liu_device_id.user_session.reload.auth_token).to_not eq(auth_token)
        end
        
        it 'sets the endpoint arn of the user', focus: true do
          device = { device_id: liu_device_id.user_session.device_id,
                       device_type: liu_device_id.user_session.device_type }
          res = { sns_endpoint_arn: "example" }

          Resque.inline = true
          client = Aws::SNS::Client.new(stub_responses: true)
          allow(Aws::SNS::Client).to receive(:new) { client }
          
          allow(client).to receive(:create_platform_endpoint).and_return(res)

 
          allow(user).to receive(:update_attributes).and_return(true)

          post :create, login_credentials.merge(device)
          
        end

        context 'someone else is logged in with the same device_id' do
          
          before do
            Resque.inline = true
          end

          it 'deletes other sessions having the same device_id' do
            device = { device_id: liu_device_id.user_session.device_id,
                       device_type: liu_device_id.user_session.device_type }
            allow(Resque).to receive(:enqueue).and_return(true)
        
            post :create, login_credentials.merge(device)
            expect(liu_device_id.reload.user_session).to eql(nil)
          end

          it 'executes the job' do
            device = { device_id: liu_device_id.user_session.device_id,
                       device_type: liu_device_id.user_session.device_type }

            client = Aws::SNS::Client.new(stub_responses: true)

            expect(Aws::SNS::Client).to receive(:new) { client }

            post :create, login_credentials.merge(device)
          end

          it 'adds AddDeviceToken to the queue' do
            device = { device_id: liu_device_id.user_session.device_id,
                       device_type: liu_device_id.user_session.device_type }
            
            expect(Resque).to receive(:enqueue).and_return(true)
            post :create, login_credentials.merge(device)
          end

        end

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