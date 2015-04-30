require 'rails_helper'

describe SubscriptionsController do

  describe "#create" do
    let(:user) { FactoryGirl.create(:user) }
    let(:subscribee) { FactoryGirl.create(:user) }
    let(:valid_params) {
      { user_id: user.id,
        subscribee_id: subscribee.id }
    }
    
    context "with valid credentials" do
      before do
        allow(controller).to receive(:current_user) { User.new }
      end

      it "returns 201" do
        post :create, valid_params
        expect(response).to have_http_status(201)
      end

      it "saves the subscription" do
        expect {
          post :create, valid_params
        }.to change(Subscription, :count).by(1)
      end          

    end

    context "with invalid credentials" do
      
      it "returns 401" do
        post :create, valid_params
        expect(response).to have_http_status(401)
      end

      it "does not save a new subscription" do
        expect {
          post :create, valid_params
        }.to change(Subscription, :count).by(0)
      end

    end

  end   

  describe "#destroy" do
    let!(:subscription) { FactoryGirl.create(:subscription) }
    let(:valid_params) {
      { user_id: subscription.user.id,
        subscribee_id: subscription.subscribee.id }
    }

    context "with valid credentials" do
      before do
        allow(controller).to receive(:current_user) { subscription.user }
      end
      
      it "returns 204" do
        delete :destroy, valid_params
        expect(response).to have_http_status(204)
      end

      it "destroys the subscription" do
        expect {
          delete :destroy, valid_params
        }.to change(Subscription, :count).by(-1)
      end

    end

    context "with invalid credentials" do
      before do
        allow(controller).to receive(:current_user) { User.new }
      end
      
      it "returns 401" do
        delete :destroy, valid_params
        expect(response).to have_http_status(401)
      end

      it "does not destroy the subscription" do
        expect {
          delete :destroy, valid_params
        }.to change(Subscription, :count).by(0)
      end

    end
  end

end
