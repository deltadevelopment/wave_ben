require 'rails_helper'

describe SearchController do

  describe "#search" do
    let!(:user) { FactoryGirl.create(:user) }
    let(:user_search_params) {
      { resource_type: "user",
        search_string: "user",
        offset: "0"
      }
    }
    
    it "returns 200" do
      post :search, user_search_params 
      expect(response).to have_http_status(200)
    end

    it "returns 404 when searching for arbitrary type" do
      post :search, user_search_params.merge({resource_type: "nonexistant"})
      expect(response).to have_http_status(404)
    end

    it "returns 404 when no results that match are found" do
      post :search, user_search_params.merge({search_string: "nonexistant"})
      expect(response).to have_http_status(404)
    end

    it "returs the requested subset" do
      FactoryGirl.create_list(:user, 9)

      post :search, user_search_params.merge({offset: "5"})

      res = JSON.parse(response.body)
      expect(res['data']['results'].length).to eq(5)
    end

    it "returns search results" do
      FactoryGirl.create(:user)

      post :search, user_search_params 

      res = JSON.parse(response.body)
      expect(res['data']['results'].length).to eq(2)
    end

    it "allows you to search hashtags too" do
      hashtag = FactoryGirl.create(:hashtag) 

      post :search, { 
        resource_type: "hashtag",
        search_string: hashtag.tag_string
      }

      res = JSON.parse(response.body)
      expect(res['data']['results'].length).to eq(1)

    end

  end

end
