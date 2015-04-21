FactoryGirl.define do
  factory :bucket do
    sequence(:title) { |n| "Here's a title#{n}" } 
    description "Here's a description"

    factory :user_bucket do
      title nil
      description nil

      bucket_type :user

    end

    factory :shared_bucket do
      bucket_type :shared 

    end

    factory :location_bucket do
      bucket_type :location

    end

  end

  trait(:everyone){
    visibility :everyone  
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

end
