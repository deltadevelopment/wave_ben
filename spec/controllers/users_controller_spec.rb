require 'rails_helper'

describe UsersController, focus: true do
  
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

      it 'logs the user in' do
        expect{
          post :create, register_params
        }.to change(UserSession, :count).by(1)
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

    end

  end

  describe '#update' do

    let(:update_params){
      {
        id: user.id,
        user: {
          password: 'newpassword',
          email: 'new@email.com',
          private_profile: false,
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

      end

    end

  end

  describe '#destroy' do

    let!(:user) { FactoryGirl.create(:user) }

    context "with the right credentials" do

      before {
        allow(controller).to receive(:current_user) { user }
      }

      it 'returns success' do
        delete :destroy, {id: user.id}
        expect(response).to be_success
      end

      it 'destroys the resource' do
        expect { 
          delete :destroy, {id: user.id}
        }.to change(User, :count).by(-1)
      end

    end

    context "with the incorrect credentials" do

        before {
          allow(controller).to receive(:current_user) { User.new }
        }

      it 'returns 401' do
        delete :destroy, {id: user.id}
        expect(response).to have_http_status(401)
      end

      it 'does not destroy the resource' do
        expect { 
          delete :destroy, {id: user.id}
        }.to change(User, :count).by(0)
      end

    end

  end

end
