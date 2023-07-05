users =
{
  "first_name": "Inventory",
  "last_name": "Manager",
  "role_id": 1, # Manager
  "email": "manager@rim.com",
  "password": "password123",
  "password_confirmation": "password123"
},
{
  "first_name": "Super",
  "last_name": "Admin",
  "role_id": 2, # Admin
  "email": "admin@rim.com",
  "password": "password123",
  "password_confirmation": "password123"
}

puts("------------------------------------")
users.each_with_index do |user, index|
  puts ("User #{index + 1} creation started")
  user = User.find_by(email: user.email, role_id: user.role_id)
end
puts ("User creation completed")
puts("------------------------------------")