require 'csv'    

namespace :seed_app_data do
  desc "Seed User from csv file"
  task seed_user: :environment do

    puts "Starting seeding user Data"
    CSV.foreach("#{Rails.root}/lib/tasks/users.csv", :headers => true) do |row|
      User.create!(row.to_hash)
    end
    puts "User data imported."
  end

  desc "Seed Events and add association with user"
  task seed_events: :environment do

    puts "Starting Event imports"
    CSV.foreach("#{Rails.root}/lib/tasks/events.csv", :headers => true) do |row|
      EventCreator.create!(row.to_hash)
    end
    puts "Event import completed."
  end

end
