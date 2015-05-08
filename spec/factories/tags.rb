FactoryGirl.define do
  factory :tag do
    association :taggable, factory: :shared_bucket

    factory :hashtag do
      sequence(:tag_string) { |n| "#tag#{n}" }
    end

    factory :usertag do
      association :taggee, factory: :user
      sequence(:tag_string) { |n| "@" + taggee.username }
    end
  end

end
