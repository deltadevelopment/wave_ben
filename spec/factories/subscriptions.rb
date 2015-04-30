FactoryGirl.define do
  factory :subscription do
    user 
    association :subscribee, factory: :user
  end

end
