FactoryGirl.define do
  factory :ripple do
    user
    
    factory(:drop_ripple) do 
      association :interaction, factory: :drop_interaction
    end

    factory(:bucket_ripple) do 
      association :interaction, factory: :bucket_interaction
    end

    trait(:seen){
      seen_at DateTime.now
    }

  end

end
