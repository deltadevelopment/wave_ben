require 'rails_helper'

describe BucketsController, type: :controller do
  
  describe "#create" do
    let(:shared_bucket) { FactoryGirl.build(:shared_bucket, :with_user) }
    let(:valid_shared_bucket_params) do
      { bucket: 
        { title: shared_bucket.title,
        media_key: SecureRandom.hex(40) } 
      }
    end

    it "tests the tests" do
      expect(shared_bucket).to be_valid
    end
    
    context "with correct credentials" do
      
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

      end

      context "with invalid parameters" do
        
        it "returns 400" do
          invalid_params = valid_shared_bucket_params[:bucket][:title] = ""
          post :create, invalid_params 
          expect(response).to have_http_status(400)
        end

      end

    end

    context "with incorrect credentials" do
      
      it "returns 401" do
        allow(controller).to receive(:current_user) { User.new }
        post :create, valid_shared_bucket_params
        expect(response).to have_http_status(401)
      end


    end

  end

  describe "#update" do
    let(:shared_bucket) { FactoryGirl.build(:shared_bucket, :with_user) }

    it "test the tests" do
      expect(shared_bucket).to be_valid 
    end

    context "with incorrect credentials" do
      
    end

  end

end
