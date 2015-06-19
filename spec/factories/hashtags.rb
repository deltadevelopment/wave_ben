FactoryGirl.define do

  factory :hashtag do
    tag_string "random"
    
    trait(:expires_1) { expires 1 }

  end  

end
