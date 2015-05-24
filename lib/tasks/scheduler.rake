task :delete_old_drops => :environment do
  puts "Deleting old drops..."
  DeleteOldDropsJob.perform_later
  puts "Done deleting old drops"
end

task :delete_empty_buckets => :environment do
  puts "Deleting empty buckets..."
  DeleteEmptyBuckets.perform_later
  puts "Done deleting empty buckets"
end
