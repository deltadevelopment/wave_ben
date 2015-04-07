require 'rails_helper'

describe UsersController do

  let(:user) { FactoryGirl.build(:user) }
  
  describe '#create' do

    let(:register_params) { 
      {'user' => {
        'username' => user.username,
        'password' => user.password,
        'email'    => user.email }
      }
    }
    
    context 'with correct parameters' do

      it 'returns success' do
        post 'create', register_params
        expect(response).to be_success
      end

      it 'saves the user' do
        expect_any_instance_of(User).to receive(:save)
        post 'create', register_params
      end

      it 'logs the user in' do
      end

    end

    it 'returns 400 when you make a mistake' do
      register_params['user']['username'] = ''
      post 'create', register_params
      expect(response).to have_http_status(400)
    end


  end

end
