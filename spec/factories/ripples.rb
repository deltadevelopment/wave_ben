FactoryGirl.define do
  factory :ripple do
    user
    message "some_message"     
    association :triggee, factory: :user
    
    factory(:drop_ripple) do 
      association :trigger, factory: :drop
    end

    factory(:bucket_ripple) do 
      association :trigger, factory: :shared_bucket
    end

    trait(:seen){
      seen_at DateTime.now
    }
  end

end
