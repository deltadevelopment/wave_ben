class Bucket < ActiveRecord::Base

   enum bucket_type: [:user, :shared, :location]
   enum visibility: [:everyone, :followers, :tagged]

end
