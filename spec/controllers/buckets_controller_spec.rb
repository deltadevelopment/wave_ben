require 'rails_helper'

describe BucketsController, type: :controller do

  let(:user) { FactoryGirl.create(:user) }
  
  describe "#create" do
    let(:shared_bucket) { FactoryGirl.build(:shared_bucket, :with_user) }
    let(:valid_shared_bucket_params) do
      { bucket: 
          { title: shared_bucket.title },
        drop: 
          { media_key: SecureRandom.hex(40),
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
      { id: shared_bucket.id,
        bucket: { title: shared_bucket.title, 
                  description: shared_bucket.description, 
                  visibility: "tagged", 
                  locked: false } 
      }
    end

    it "test the tests" do
      expect(shared_bucket).to be_valid 
    end

    context "with valid credentials" do
      
      context "with valid parameters" do

        before do
          allow(controller).to receive(:current_user) { shared_bucket.user }
        end
        
        it "returns 200" do
          post :update, valid_shared_bucket_params
          expect(response).to have_http_status(200)
        end

        it "updates the record" do
          post :update, valid_shared_bucket_params
          expect(shared_bucket.reload.title).to eq(valid_shared_bucket_params[:bucket][:title])

        end

      end

    end

    context "with invalid credentials" do

      it "returns 401" do
        allow(controller).to receive(:current_user) { user }
        post :update, valid_shared_bucket_params
        expect(response).to have_http_status(401)
      end 
      
    end

  end

  describe "#destroy" do
    let!(:shared_bucket) { FactoryGirl.create(:shared_bucket, :with_user) }

    context "with valid credentials" do

      before do
        allow(controller).to receive(:current_user) { shared_bucket.user }
      end
      
      it "returns 200" do
        delete :destroy, { id: shared_bucket.id }
        expect(response).to have_http_status(200)
      end

      it "deletes the record" do
        expect{ 
          delete :destroy, { id: shared_bucket.id }
        }.to change(Bucket, :count).by(-1)
      end

    end

    context "with invalid credentials" do
      before do
        allow(controller).to receive(:current_user) { User.new }
      end

      it "returns 401" do
        delete :destroy, { id: shared_bucket.id }
        expect(response).to have_http_status(401)
      end

      it "does not delete the record" do
        expect{ 
          delete :destroy, { id: shared_bucket.id }
        }.to change(Bucket, :count).by(0)
      end

    end

  end



end