FactoryGirl.define do
  factory :bucket do
    
    transient do
      taggee nil
    end

    factory :user_bucket do
      bucket_type :user
    end

    factory :shared_bucket do
      bucket_type :shared 

      sequence(:title) { |n| "Here's a title#{n}" } 
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

    trait(:with_user_with_subscriber){
      user { create(:user, :with_subscriber) }
    }

    trait(:with_watcher){
      after(:create) do |bucket|
        create(:watcher, watchable: bucket)
      end
    }

    trait(:with_taggee) do
      after(:create) do |bucket, evaluator|
        if evaluator.taggee
          create(:usertag, taggable: bucket, user: evaluator.taggee)
        else
          create(:usertag, taggable: bucket)
        end
      end     
    end

  end

end
