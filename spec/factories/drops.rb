FactoryGirl.define do
  factory :drop do
    user

    sequence(:media_key) { |n| "99998c9595dda1242800850f1aaf2a4e28e50ba46801d0b52f319f1c9477091f264cc2427889c82#{n}" }
    sequence(:thumbnail_key) { |n| "89998c9595dda1242800850f1aaf2a4e28e50ba46801d0b52f319f1c9477091f264cc2427889c82#{n}" }
    media_type 1
  end

  trait(:with_shared_bucket) { 
    association :bucket, factory: [:shared_bucket, :with_user]
  }
  
  trait(:with_user_bucket) { 
    association :bucket, factory: [:user_bucket, :with_user]
  }

end
