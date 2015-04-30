FactoryGirl.define do

  factory :user do
    sequence(:username) { |n| "user#{n}" } 
    sequence(:email) { |n| "user#{n}@gmail.com" } 
    sequence(:phone_number) { |n| "1234567#{n}".to_i } 
    display_name "Wave Rider"
    password "blackhatpr00f"
    availability 0
    private_profile false

    trait(:with_bucket){
      after(:create) do |user|
        create(:user_bucket, user: user)
      end
    }

    trait(:private) { private_profile true }
    trait(:logged_in) { user_session { create(:user_session) } }
    trait(:logged_in_with_device_id) { user_session { create(:user_session, :with_device_id) } }
  end

end
