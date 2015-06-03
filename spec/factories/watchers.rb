FactoryGirl.define do
  factory :watcher do
    user     

    factory :drop_watcher do
      association :watchable, factory: :drop
    end

    factory :bucket_watcher do
      association :watchable, factory: :shared_bucket
    end

  end

end
