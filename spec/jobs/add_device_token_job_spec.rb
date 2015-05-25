require 'rails_helper'

describe AddDeviceTokenJob do
  let(:user) { FactoryGirl.create(:user, :with_bucket) }
  let(:update_token_params){
    { arn: 'A'*16,
      device_id: 'A'*16,
      user_id: user.id
    }
  }

  it "adds the device_id to sns if it does not exist" do
    client = Aws::SNS::Client.new(stub_responses: true)
    allow(Aws::SNS::Client).to receive(:new) { client } 
    expect(client).to receive(:create_platform_endpoint).and_return({
      endpoint_arn: 'arn'
    })

    AddDeviceTokenJob.new.perform(update_token_params)
  end

  it "replaces the existing device_id if it already exists" do
    client = Aws::SNS::Client.new(stub_responses: true)
    allow(Aws::SNS::Client).to receive(:new) { client } 
    expect(client).to receive(:set_endpoint_attributes).and_return({
      endpoint_arn: 'arn'
    })

    AddDeviceTokenJob.new.perform(update_token_params, 'example')
  end

  it "adds endpoint_arn to the requesting user" do
    client = Aws::SNS::Client.new(stub_responses: true)
    allow(Aws::SNS::Client).to receive(:new) { client } 
    allow(client).to receive(:create_platform_endpoint).and_return({
      endpoint_arn: 'arn' 
    })
    
    AddDeviceTokenJob.new.perform(update_token_params)
    expect(user.reload.sns_endpoint_arn).to eql('arn')
  end
end
