FactoryGirl.define do
  factory :vote do
    user
    drop
    association :bucket, factory: :user_bucket
    temperature 50
  end

end
