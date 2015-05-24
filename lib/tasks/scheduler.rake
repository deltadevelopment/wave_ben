task :delete_old_drops => :environment do
  puts "Deleting old drops..."
  DeleteOldDropsJob.perform_later
  puts "Done deleting old drops"
end
