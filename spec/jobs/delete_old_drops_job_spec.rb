require 'rails_helper'

describe DeleteOldDropsJob do
  let!(:drop) { FactoryGirl.create(:drop, :with_shared_bucket, created_at: DateTime.now-48.hours) }

  before{
    Resque.inline = true  
  }
  
  it "deletes old drops" do
    FactoryGirl.create(:drop)
    expect{
      DeleteOldDropsJob.new.enqueue
    }.to change(Drop, :count).by(-1) 
  end

end
