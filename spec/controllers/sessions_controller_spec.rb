require 'rails_helper'

describe SessionsController do

  describe '#create' do

    let(:user) { FactoryGirl.create(:user) }
    let(:login_credentials) { 
      { username: user.username,
        password: user.password }
    }
    
    context 'incorrect credentials' do

      it 'returns 401' do
        post 'create', { username: '', password: '' }
        expect(response).to have_http_status(401)        
      end

    end

    context 'correct credentials' do
      
      it 'returns 200' do
        post 'create', login_credentials
        expect(response).to be_success
      end
          
    end

  end

end
