FactoryGirl.define do
  factory :vote do
    user
    association :drop, factory: [:drop, :with_shared_bucket]
    association :bucket, factory: :user_bucket
    vote 1
  end

end
