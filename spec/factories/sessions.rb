FactoryGirl.define do
  factory :session do
    sequence(:auth_token) { |n| "a1f8e05fabf570d033531c8a4c8a8ae#{n}" }
  end

end
