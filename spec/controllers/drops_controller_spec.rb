require 'rails_helper'

describe DropsController do

  describe "#create" do
    let!(:drop) { FactoryGirl.build(:drop, :with_bucket) }
    let(:valid_params) {
      { bucket_id: drop.bucket.id,
        drop: { 
          media_key: drop.media_key
        }
      }
    }

    context "with valid credentials" do
      before do
        allow(controller).to receive(:current_user) { drop.bucket.user } 
      end

      it "returns 200 when adding a drop to a bucket" do
        post :create, valid_params
        expect(response).to have_http_status(201)
      end

      it "saves the drop" do
        expect{
          post :create, valid_params
        }.to change(Drop, :count).by(1)
      end
  
      it "returns 400 with invalid parameters" do
        post :create, { bucket_id: drop.bucket.id }
        expect(response).to have_http_status(400)
      end

      it "returns 404 if the bucket does not exist" do
        post :create, { bucket_id: 200 }
        expect(response).to have_http_status(404)
      end

    end

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
