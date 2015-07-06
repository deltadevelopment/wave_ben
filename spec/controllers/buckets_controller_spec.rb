require 'rails_helper'

describe BucketsController do

  let(:user) { FactoryGirl.create(:user) }
  
  describe "#create" do
    let(:shared_bucket) { FactoryGirl.build(:shared_bucket, :with_user) }
    let(:drop) { FactoryGirl.build(:drop) }
    let(:valid_shared_bucket_params) do
      { bucket: 
          { title: shared_bucket.title },
        drop: 
          { media_key: drop.media_key,
            media_type: drop.media_type,
            thumbnail_key: drop.thumbnail_key,
            caption: "Some caption" } 
      }
    end


    it "tests the tests" do
      expect(shared_bucket).to be_valid
    end
    
    context "with valid credentials" do

      before{
        allow(controller).to receive(:current_user) { shared_bucket.user }
      }
      
      context "with valid parameters" do
        
        it "returns 200" do
          post :create, valid_shared_bucket_params
          expect(response).to be_success
        end

        it "saves the bucket" do
          expect { 
            post :create, valid_shared_bucket_params 
          }.to change(Bucket, :count).by(1)
        end

        it "saves the drop" do
          expect { 
            post :create, valid_shared_bucket_params 
          }.to change(Drop, :count).by(1)
        end

      end

      context "with invalid parameters" do
        before{
          allow(controller).to receive(:current_user) { shared_bucket.user }
          @invalid_params = valid_shared_bucket_params[:bucket][:title] = ""
        }
        
        it "returns 400" do
          post :create, @invalid_params 
          expect(response).to have_http_status(400)
        end

        it "does not save the bucket" do
          expect{ 
            post :create, @invalid_params 
          }.to change(Bucket, :count).by(0)
        end

        it "does not save the drop" do
          expect{ 
            post :create, @invalid_params 
          }.to change(Drop, :count).by(0)
        end

      end

    end

    context "with invalid credentials" do
      
      it "returns 401" do
        post :create, valid_shared_bucket_params
        expect(response).to have_http_status(401)
      end

      it "does not save the bucket" do
        expect{
          post :create, valid_shared_bucket_params
        }.to change(Bucket, :count).by(0)
      end

      it "does not save the drop" do
        expect{
          post :create, valid_shared_bucket_params
        }.to change(Drop, :count).by(0)
      end

    end

  end

  describe "#update" do
    let(:shared_bucket) { FactoryGirl.create(:shared_bucket, :with_user) }
    let(:valid_shared_bucket_params) do
      { bucket_id: shared_bucket.id,
        bucket: { title: shared_bucket.title, 
                  visibility: "taggees"
        } 
      }
    end

    it "test the tests" do
      expect(shared_bucket).to be_valid 
    end

    context "with valid credentials" do

      context "with invalid parameters" do

        before do
          allow(controller).to receive(:current_user) { shared_bucket.user }
        end

        it "returns 404 when bucket does not exist" do
          put :update, { bucket_id: 150 }
          expect(response).to have_http_status(404)
        end

        it "returns 400 with bad parameters" do
          put :update, { bucket_id: shared_bucket.id }
          expect(response).to have_http_status(400)
        end

      end
      
      context "with valid parameters" do

        before do
          allow(controller).to receive(:current_user) { shared_bucket.user }
        end
        
        it "returns 200" do
          put :update, valid_shared_bucket_params
          expect(response).to have_http_status(200)
        end

        it "updates the record" do
          put :update, valid_shared_bucket_params
          expect(shared_bucket.reload.title).to eq(valid_shared_bucket_params[:bucket][:title])

        end

      end

    end

    context "with invalid credentials" do

      it "returns 401" do
        allow(controller).to receive(:current_user) { user }
        put :update, valid_shared_bucket_params
        expect(response).to have_http_status(401)
      end 
      
    end

  end

  describe "#destroy" do
    let!(:shared_bucket) { FactoryGirl.create(:shared_bucket, :with_user, :with_drop) }

    context "with valid credentials" do

      before do
        allow(controller).to receive(:current_user) { shared_bucket.user }
      end
      
      it "returns 204" do
        delete :destroy, { bucket_id: shared_bucket.id }
        expect(response).to have_http_status(204)
      end

      it "deletes the record" do
        expect{ 
          delete :destroy, { bucket_id: shared_bucket.id }
        }.to change(Bucket, :count).by(-1)
      end

      it "returns 404 when the record does not exist" do
        delete :destroy, { bucket_id: 150 }
        expect(response).to have_http_status(404)
      end

    end

    context "with invalid credentials" do
      before do
        allow(controller).to receive(:current_user) { User.new }
      end

      it "returns 401" do
        delete :destroy, { bucket_id: shared_bucket.id }
        expect(response).to have_http_status(401)
      end

      it "does not delete the record" do
        expect{ 
          delete :destroy, { bucket_id: shared_bucket.id }
        }.to change(Bucket, :count).by(0)
      end

    end

  end

  describe "#watch" do
    let(:user_bucket) { FactoryGirl.create(:user_bucket, :with_user) }

    before do
      allow(controller).to receive(:current_user) { user_bucket.user }
    end

    it "returns 201" do
      post :watch, { bucket_id: user_bucket.id } 
      expect(response).to have_http_status(201)
    end

    it "returns 404 when it doesn't exist" do
      post :watch, { bucket_id: 500 }
      expect(response).to have_http_status(404)
    end

  end

  describe "#unwatch" do
    let(:watcher) { FactoryGirl.create(:bucket_watcher) }

    before do
      allow(controller).to receive(:current_user) { watcher.user }
    end
    
    it "returns 204" do
      delete :unwatch, { bucket_id: watcher.watchable.id }
      expect(response).to have_http_status(204)
    end

    it "returns 404 when it doesn't exist" do
      delete :unwatch, { bucket_id: 500 }
      expect(response).to have_http_status(404)
    end

  end

  describe "#buckets_for_user" do
    let(:user) { FactoryGirl.create(:user, :with_bucket) }
    let(:user2) { FactoryGirl.create(:user) }

    before do
      allow(controller).to receive(:current_user) { user2 }
    end
  
    it "returns 200" do
      get :buckets_for_user, { user_id: user.id }
      expect(response).to have_http_status(200)
    end

    it "does not return private buckets you arent tagged in" do
      FactoryGirl.create(:shared_bucket, :taggees, user: user)

      get :buckets_for_user, { user_id: user.id }

      res = JSON.parse(response.body)
      expect(res['data']['buckets'].length).to eq(1)
    end

    it "returns private buckets you are tagged in" do
      bucket = FactoryGirl.create(:shared_bucket, :taggees, user: user)
      FactoryGirl.create(:usertag, taggee: user2, taggable: bucket)

      get :buckets_for_user, { user_id: user.id }

      res = JSON.parse(response.body)
      expect(res['data']['buckets'].length).to eq(2)
    end
    
  end

end
