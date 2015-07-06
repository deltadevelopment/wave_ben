require 'rails_helper'

describe RipplesController do
  let!(:ripple) { FactoryGirl.create(:bucket_ripple) }

  describe "#list" do
    before do
      allow(controller).to receive(:current_user) { ripple.user }
    end
    
    it "returns 200" do
      get :list
      expect(response).to have_http_status(200)
    end

    it "returns 404 with no results" do
      allow(controller).to receive(:current_user) { User.new }
      get :list
      expect(response).to have_http_status(404)
    end

    describe "it returns all ripples" do
      let(:user) { FactoryGirl.create(:user) }
      
      before do
        3.times do 
          FactoryGirl.create(:bucket_ripple, user: user)
        end 

        allow(controller).to receive(:current_user) { user }
      end
      
      it "returns 3 ripples" do
        get :list
        res = JSON.parse(response.body)
        expect(res['data']['ripples'].length).to eq(3)
      end

    end

  end

end
