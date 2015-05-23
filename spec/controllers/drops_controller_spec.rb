require 'rails_helper'

describe DropsController do

  describe "#create" do
    let!(:drop) { FactoryGirl.build(:drop, :with_shared_bucket) }
    let(:valid_params) {
      { bucket_id: drop.bucket.id,
        drop: { 
          media_key: drop.media_key,
          media_type: drop.media_type,
          thumbnail_key: drop.thumbnail_key
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

  describe "#destroy" do
    let!(:drop) { FactoryGirl.create(:drop, :with_shared_bucket) }
    let(:valid_params) { { drop_id: drop.id } }

    before do
      allow(controller).to receive(:current_user) { drop.user }
    end
    
    it "returns 204 when deleting the drop" do
      delete :destroy, valid_params
      expect(response).to have_http_status(204)
    end

    it "deletes the record" do
      expect{
        delete :destroy, valid_params
      }.to change(Drop, :count).by(-1)
    end

    it "returns 404 if the drop does not exist" do
      delete :destroy, { drop_id: 0 }
      expect(response).to have_http_status(404)
    end

    context "with invalid credentials" do

      it "returns 401 with invalid credentials" do
        allow(controller).to receive(:current_user) { User.new }
        delete :destroy, valid_params
        expect(response).to have_http_status(401)
      end

    end

  end

  describe "#generate_upload_url" do

    context "with valid credentials" do

      before { allow(controller).to receive(:current_user) { User.new } } 
      
      it "returns 200" do
        allow(controller).to receive(:aws_generate_upload_url) {
          ["url", "key"]
        }
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

  describe "#vote" do
    let!(:drop) { FactoryGirl.create(:drop, :with_shared_bucket, :with_user) }
    let(:valid_params) {
      { drop_id: drop.id,
        vote: {
          temperature: 50
        }
      }
    }

    before { allow(controller).to receive(:current_user) { drop.user }
    }

    it "returns 201" do
      post :vote, valid_params
      expect(response).to have_http_status(201)
    end 

    it "returns 404 for a drop that does not exist" do
      post :vote, valid_params.merge({drop_id: 500})
      expect(response).to have_http_status(404)
    end

    it "returns 400 without a temperature" do
      valid_params[:vote].delete(:temperature)
      post :vote, valid_params
      expect(response).to have_http_status(400)
    end

  end

end
