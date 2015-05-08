require 'rails_helper'

describe DropsController do

  # Scenario
  #   - Bucket is locked / unlocked
  #   - Bucket is visible to: everyone, friends, tagged

  describe "#create" do
    let!(:drop) { FactoryGirl.build(:drop, :with_bucket) }
    let(:valid_params) {
      { bucket_id: drop.bucket.id,
        drop: { 
          media_key: drop.media_key
        }
      }
    }
  

  end

  describe "#generate_upload_url" do

    context "with valid credentials" do

      before { allow(controller).to receive(:current_user) { User.new } } 
      
      it "returns 200" do
        post :generate_upload_url
        expect(response).to have_http_status(200)
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
