FactoryGirl.define do
  factory :interaction do
    user
    action "create"

    factory :drop_interaction do
      association :topic, factory: :drop
    end 

    factory :bucket_interaction do
      association :topic, factory: :user_bucket
    end 

  end

end
