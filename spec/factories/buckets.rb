FactoryGirl.define do
  factory :bucket do

    factory :user_bucket do
      bucket_type :user
    end

    factory :shared_bucket do
      bucket_type :shared 

      sequence(:title) { |n| "Here's a title#{n}" } 
    end

  end

  trait(:everyone){
    visibility :everyone  
  }

  trait(:taggees){
    visibility :taggees
  }

  trait(:with_drop){
    after(:create) do |bucket|
      create(:drop, bucket: bucket, user: create(:user))
    end
  }

  trait(:with_unsaved_drop){
    after(:create) do |bucket|
      build(:drop, bucket: bucket)
    end
  }

  trait(:with_user){
    user { create(:user) }
  }

  trait(:with_taggee){
    after(:create) do |bucket|
      create(:usertag, taggable: bucket)
    end     
  }

end
