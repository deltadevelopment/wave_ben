require 'rails_helper'

describe InteractionsController do
  
  describe "#create" do
    let(:interaction) { FactoryGirl.create(:interaction) }
    let(:valid_params) { 
      { interaction: { 
        user_id: interaction.user_id,
        topic_type: interaction.topic_type,
        topic_id: interaction.topic_id,
        action: "create_chat_message" }
      }
    }

      before {
        allow(controller).to receive(:check_valid_authorization) { true }
      }
      
      it "returns 201" do
        post :create, valid_params
        expect(response).to have_http_status(201)
      end

      it "returns 400 with errors" do
        post :create, { interaction: {} }
        expect(response).to have_http_status(400) 
      end

  end

end
