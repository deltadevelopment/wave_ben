require 'rails_helper'

describe TagsController do

  describe "#create" do
    let(:bucket) { FactoryGirl.create(:shared_bucket, :with_user) }
    let(:valid_params) do
      { bucket_id: bucket.id,
        tag: {
          tag_string: "#juice"
        }
      }
    end
    
    it "returns 200 when creating a new tag" do
      allow(controller).to receive(:current_user) { bucket.user }
      post :create, valid_params
    end

    it "saves the tag" do
      allow(controller).to receive(:current_user) { bucket.user }
      expect{
        post :create, valid_params
      }.to change(Tag, :count).by(1)
    end

    it "returns 401 without the proper permissions" do
      allow(controller).to receive(:current_user) { User.new }
      post :create, valid_params
      expect(response).to have_http_status(401)
    end

    it "returns 400 when attemping to tag a user bucket" do
      bucket = FactoryGirl.create(:user_bucket, :with_user)
      valid_params[:bucket_id] = bucket.id

      allow(controller).to receive(:current_user) { bucket.user }

      post :create, valid_params
      expect(response).to have_http_status(400)
    end

  end 

  describe "#destroy" do
    
    it "returns 204 when deleting a tag" do
      bucket = FactoryGirl.create(:shared_bucket, :with_user, :with_taggee)
      allow(controller).to receive(:current_user) { bucket.user }

      delete :destroy, { tag_id: bucket.tags[0].id }
      expect(response).to have_http_status(204)
    end

    it "deletes the tag" do
      bucket = FactoryGirl.create(:shared_bucket, :with_user, :with_taggee)
      allow(controller).to receive(:current_user) { bucket.user }

      expect{
        delete :destroy, { tag_id: bucket.tags[0].id }
      }.to change(Tag, :count).by(-1)
    end

  end


end
