# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require "pp"

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

# General Configuration

ENV["load_test_data"] = "false"
ENV["load_all_templates"] = "true"

#
# Re-run a specific seed_file only
# Eg: `rake db:seed load_only=000_practices.rb`
#
if ENV["load_only"].present? then
  seed_file = "#{File.join(Rails.root, 'db', 'seeds', ENV["load_only"])}"
  load seed_file
  exit
end


pp "Running All Seed Files..."

unless Rails.env.production?
  pp "With option: ENV['load_test_data'] = 'true'"
  ENV["load_test_data"] = "true"

  pp "With option: ENV['load_all_templates'] = 'false'"
  ENV["load_all_templates"] = "false"
end

Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each { |seed_file|

  file_name = seed_file.split('/').last

  if ENV["load_test_data"] == "true"
    load seed_file
  else
    load seed_file if file_name.starts_with("0")
  end

}

pp "Completed!"