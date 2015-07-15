require 'rails_helper'

describe FeedController do

  describe "#list" do
    let(:user) { FactoryGirl.create(:user, :with_subscription) }
    
    context "it shows public content the user subscribes to" do

      before do
        allow(controller).to receive(:current_user) { user }
      end
      
      it "returns 200" do
        get :list
        expect(response).to have_http_status(200)
      end 

      it "returns a bucket for my subscription" do
        FactoryGirl.create(:user_bucket, :with_drop, 
                           user: user.subscribees[0].user)
        get :list
        res = JSON.parse(response.body)
        expect(res['data']['buckets'].length).to eq(1)
      end 
    end 

 #    context "it shows tagged content the user is tagged in" do
 #      let(:bucket) { FactoryGirl.create(:shared_bucket, :with_user, :with_taggee, with_user: user.subscriptions.first.user, taggee: user) }

 #      before do
 #        allow(controller).to receive(:current_user) { user }
 #      end

 #      it "returns a tagged bucket for my subscriptions" do
 #        get :list
 #        res = JSON.parse(response.body)
 #        expect(res['data']['buckets'].length).to eq(1)
 #      end 
 #    end 



  end

end
