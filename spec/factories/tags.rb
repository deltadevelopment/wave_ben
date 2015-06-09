FactoryGirl.define do
  factory :tag do
    association :taggable, factory: [:shared_bucket, :with_user]

    factory :tag_hashtag do
      tag_string "#random123"
    end

    factory :usertag do
      association :taggee, factory: :user
      sequence(:tag_string) { |n| "@" + taggee.username }
    end

    trait(:with_hashtag) do
      association :taggee, factory: :hashtag
    end
    
    trait(:with_saved_hashtag) do
      association :taggee, factory: :hashtag, strategy: :create
    end

  end

end
