require 'rails_helper'

describe RipplesController do
  let!(:ripple) { FactoryGirl.create(:bucket_ripple) }

  describe "#list" do
    before do
      allow(controller).to receive(:current_user) { ripple.user }
    end
    
    it "returns 200" do
      post :list
      expect(response).to have_http_status(200)
    end

    it "returns 404 with no results" do
      allow(controller).to receive(:current_user) { User.new }
      post :list
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
        post :list
        res = JSON.parse(response.body)
        expect(res['data']['ripples'].length).to eq(3)
      end

    end

  end

  describe "#create" do
    let(:ripple) { FactoryGirl.create(:drop_ripple) }
    let(:valid_params) do
      { ripple: 
        { user: ripple.user,
          message: ripple.message,
          pushable: ripple.pushable,
          trigger_id: ripple.trigger_id,
          trigger_type: ripple.trigger_type,
          triggee_id: ripple.triggee_id
        }
      }
    end

    context "with proper credentials" do

      before do
        allow(controller).to receive(:check_valid_authorization) { true }
      end

      it "returns 201" do
        post :create, valid_params
        expect(response).to have_http_status(201)
      end

      it "returns 400 with invalid params" do
        post :create, valid_params[:ripple].merge({message: nil})
        expect(response).to have_http_status(400)
      end

    end

    it "returns 401 without proper authorization" do
      post :create, valid_params
      expect(response).to have_http_status(401)
    end

  end

end
