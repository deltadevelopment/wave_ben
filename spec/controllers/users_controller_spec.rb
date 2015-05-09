require 'rails_helper'

describe UsersController do
  
  describe '#create' do

    let(:user) { FactoryGirl.build(:user) }

    let(:register_params) { 
      {'user' => {
        'username' => user.username,
        'password' => user.password,
        'email'    => user.email }
      }
    }
    
    context 'with correct parameters' do

      it 'returns success' do
        post :create, register_params
        expect(response).to be_success
      end

      it 'saves the user' do
        expect{
          post :create, register_params
        }.to change(User, :count).by(1)
      end

      it 'logs the user in' do
        expect{
          post :create, register_params
        }.to change(UserSession, :count).by(1)
      end

      it 'creates a new user bucket' do
        expect{
          post :create, register_params
        }.to change(Bucket, :count).by(1)
      end

    end

    context 'with incorrect parameters' do

      it 'returns 400 when you make a mistake' do
        register_params['user']['username'] = ''
        post :create, register_params
        expect(response).to have_http_status(400)
      end

      it 'returns 400 when you dont include `user`' do
        post :create 
        expect(response).to have_http_status(400)
      end

      it 'does not save the user' do
        register_params['user']['username'] = ''
        expect{
          post :create, register_params
        }.to change(User, :count).by(0)
      end

      it 'does not create a new bucket' do
        register_params['user']['username'] = ''
        expect{
          post :create, register_params
        }.to change(Bucket, :count).by(0)
      end

    end

  end

  describe '#update' do

    let(:update_params){
      {
        user_id: user.id,
        user: {
          password: 'newpassword',
          email: 'new@email.com',
          phone_number: 12345678
        }
      }
    }

    let!(:user) { FactoryGirl.create(:user) }

    context 'with invalid credentials' do

      it 'returns 401' do
        allow(controller).to receive(:current_user) { User.new }
        put :update, update_params
        expect(response).to have_http_status(401)
      end

    end
    
    context 'with valid credentials' do

    before {
      allow(controller).to receive(:current_user) { user }
    }

      context 'with the right params' do

        it 'returns success' do
          put :update, update_params
          expect(response).to be_success
        end

        it 'changes the email' do
          put :update, update_params 
          expect(user.reload.email).to eq(update_params[:user][:email])
        end

      end

      context 'with incorrect params' do
        
        it 'returns 400' do
          put :update, update_params.merge({user: {email: 'wrong'}})
          expect(response).to have_http_status 400
        end 

        it 'returns 404' do
          put :update, { user_id: 150 }
          expect(response).to have_http_status 404
        end

      end

    end

  end

  describe '#destroy' do

    let!(:user) { FactoryGirl.create(:user, :with_bucket) }

    context "with the right credentials" do

      before {
        allow(controller).to receive(:current_user) { user }
      }

      it 'returns success' do
        delete :destroy, {user_id: user.id}
        expect(response).to have_http_status(204)
      end

      it 'destroys the user' do
        expect { 
          delete :destroy, {user_id: user.id}
        }.to change(User, :count).by(-1)
      end

      it 'returns 404 for non-existing users' do
        delete :destroy, { user_id: 200 }
        expect(response).to have_http_status(404)
      end

    end

    context "with the incorrect credentials" do

        before {
          allow(controller).to receive(:current_user) { User.new }
        }

      it 'returns 401' do
        delete :destroy, {user_id: user.id}
        expect(response).to have_http_status(401)
      end

      it 'does not destroy the resource' do
        expect { 
          delete :destroy, {user_id: user.id}
        }.to change(User, :count).by(0)
      end

    end

  end

end
