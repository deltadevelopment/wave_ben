FactoryGirl.define do
  factory :bucket do

    factory :user_bucket do
      bucket_type :user
    end

    factory :shared_bucket do
      bucket_type :shared 

      sequence(:title) { |n| "Here's a title#{n}" } 
      description "Here's a description"

      when_datetime DateTime.new.to_s
    end

  end

  trait(:everyone){
    visibility :everyone  
  }

  trait(:with_drop){
    after(:create) do |bucket|
      create(:drop, bucket: bucket)
    end
  }

  trait(:followers){
    visibility :followers
  }

  trait(:tagged){
    visibility :tagged
  }

  trait(:locked){
    locked true
  }

  trait(:open){
    locked false 
  }

  trait(:with_user){
    user { create(:user) }
  }

end
