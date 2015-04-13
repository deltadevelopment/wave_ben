FactoryGirl.define do

  factory :user_session do
    sequence(:auth_token) { |n| "a1f8e05fabf570d033531c8a4c8a8ae#{n}" }

    trait(:with_device_id) {  
      sequence(:device_id) { |n| "410dd0a5bdbf333de0b92703db2b9da80161b43ed1489a133cf949e9a82d3ee#{n}" }
      device_type 'ios'
    }
  end

end
