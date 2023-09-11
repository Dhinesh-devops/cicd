roles = ["Manager", "Admin"]

puts ("Roles creation started")
puts("------------------------------------")
roles.each do |role|
  Role.find_or_create_by(name: role)
end
puts ("Roles creation completed")
puts("------------------------------------")