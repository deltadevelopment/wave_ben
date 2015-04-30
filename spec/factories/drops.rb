FactoryGirl.define do
  factory :drop do
    sequence(:media_key) { |n| "99998c9595dda1242800850f1aaf2a4e28e50ba46801d0b52f319f1c9477091f264cc2427889c82#{n}" }
  end

  trait(:with_bucket) { 
    association :bucket, factory: :shared_bucket 
  }

end
