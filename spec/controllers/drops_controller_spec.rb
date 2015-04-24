require 'rails_helper'

describe DropsController do

  describe "#generate_upload_url" do

    context "with valid credentials" do

      before { allow(controller).to receive(:current_user) { User.new } } 
      
      it "returns 201" do
        post :generate_upload_url
        expect(response).to have_http_status(201)
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
