require 'rails_helper'

describe DropsController do

  # Scenario
  #   - Bucket is locked / unlocked
  #   - Bucket is visible to: everyone, friends, tagged

  describe "#create" do
    let!(:drop) { FactoryGirl.build(:drop, :with_bucket) }
    let(:valid_drop_params) {
      { id: drop.bucket.id,
        drop: { 
          media_key: drop.media_key
        }
      }
    }
  
    context "with valid credentials" do 
      
    end

    context "without being logged in" do 
      
      it "should return 401" do
        post :create, valid_drop_params 
        expect(response).to have_http_status(401)
      end

    end

  end

  describe "#generate_upload_url" do

    context "with valid credentials" do

      before { allow(controller).to receive(:current_user) { User.new } } 
      
      it "returns 201" do
        post :generate_upload_url
        expect(response).to have_http_status(201)
      end

    end

    context "with invalid credentials" do

      it "returns 401" do
        post :generate_upload_url
        expect(response).to have_http_status(401)
      end

    end

  end

end
