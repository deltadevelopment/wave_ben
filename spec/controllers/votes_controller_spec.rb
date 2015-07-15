require 'rails_helper'

describe VotesController do

  describe "#list" do
    let(:user) { FactoryGirl.create(:user) }
    let(:vote) { FactoryGirl.create(:vote) }
    let(:drop) { FactoryGirl.create(:drop, :with_shared_bucket) }
    let(:valid_params) do
      { vote: { vote: 1 },
        drop_id: vote.drop.id
      }
    end

    before do
      allow(controller).to receive(:current_user) { user }
    end

    it "returns 200" do
      get :list, valid_params
      expect(response).to have_http_status(200)
    end

    it "returns 404 for drops that do not exist" do
      get :list, valid_params.merge({drop_id: 200})
      expect(response).to have_http_status(404)
    end

    it "returns an empty array with no votes" do
      get :list, valid_params.merge({drop_id: drop.id})

      res = JSON.parse(response.body)
      expect(res['data']['votes'].length).to eq(0)
    end

    it "returns an array of votes" do
      get :list, valid_params

      res = JSON.parse(response.body)
      expect(res['data']['votes'].length).to eq(1)
    end

  end

  describe "#create" do
    let!(:drop) { FactoryGirl.create(:drop, :with_shared_bucket, :with_user) }
    let(:user) { FactoryGirl.create(:user) }

    let(:valid_params) {
      { drop_id: drop.id,
        vote: {
          vote: 1
        }
      }
    }

    before { allow(controller).to receive(:current_user) { user } }

    it "returns 201" do
      post :create, valid_params
      expect(response).to have_http_status(201)
    end 

    it "returns 404 for a drop that does not exist" do
      post :create, valid_params.merge({drop_id: 500})
      expect(response).to have_http_status(404)
    end

    it "returns 400 without a vote" do
      valid_params[:vote].delete(:vote)
      post :create, valid_params
      expect(response).to have_http_status(400)
    end

  end

  describe "#destroy" do
    let(:vote) { FactoryGirl.create(:vote) }

    before { allow(controller).to receive(:current_user) { vote.user } }

    it "returns 204" do
      delete :destroy, { vote_id: vote.id }
      expect(response).to have_http_status(204)
    end

  end

end
