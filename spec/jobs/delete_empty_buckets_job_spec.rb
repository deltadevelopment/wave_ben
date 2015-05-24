require 'rails_helper'

describe DeleteEmptyBucketsJob do

  before{
    Resque.inline = true
  }

  it "deletes empty shared buckets" do
    FactoryGirl.create(:shared_bucket)
    expect{
      DeleteEmptyBucketsJob.new.enqueue
    }.to change(Bucket, :count).by(-1)
  end

  it "does not delete shared buckets with drops in" do
    FactoryGirl.create(:shared_bucket, :with_drop)
    expect{
      DeleteEmptyBucketsJob.new.enqueue
    }.to change(Bucket, :count).by(0)
  end

  it "does not delete user buckets" do
    FactoryGirl.create(:user_bucket)
    expect{
      DeleteEmptyBucketsJob.new.enqueue
    }.to change(Bucket, :count).by(0)
  end

end
