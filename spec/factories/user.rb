FactoryGirl.define do

  factory :user do
    sequence(:username) { |n| "user#{n}" } 
    sequence(:email) { |n| "user#{n}@gmail.com" } 
    sequence(:phone_number) { |n| "1234567#{n}".to_i } 
    display_name "Wave Rider"
    password "blackhatpr00f"
    availability 0


    trait(:public) { private_profile false }
    trait(:private) { private_profile true }
    trait(:logged_in) { session { create(:session) } }
  end

end
