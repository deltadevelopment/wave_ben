require 'rails_helper'

describe FollowingsController do

  describe "#create_or_request" do
    let(:private_followee) { FactoryGirl.create(:user, :private) }
    let(:open_followee) { FactoryGirl.create(:user) }
    let(:user) { FactoryGirl.create(:user) }

    context "with valid credentials" do

      context "user does not exist" do

        it "returns 404" do
          post :create_or_request, { user_id: 50, followee_id: 60 }      
          expect(response).to have_http_status(404)
        end

      end
    
      context "followee is private" do
        
        it "returns 201" 

        it "creates a new followingrequest"

        it "does not create a new following" 

      end 
          
      context "followee is not private" do
       
        it "returns 201" do
          req = { user_id: user.id, followee_id: open_followee.id }
          post :create_or_request, req
          expect(response).to have_http_status(201)
        end

        it "creates a new following"

        it "does not create a new followingrequest" 

      end 

    end

    context "with invalid credentials" do

      it "returns 401"

      it "does not save a following" 

      it "does not save a followingrequest" 
    
    end

  end


end
