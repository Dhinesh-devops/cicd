# Todo: change the admin email id before running this seed file
admin_user_array =
[ {
  "first_name": "Super",
  "last_name": "Admin",
  "role_id": 2, # Admin
  "email": "admin@rim.com",
  "password": "password123",
  "password_confirmation": "password123"
} ]

puts("------------------------------------")
admin_user_array.each_with_index do |admin_user, index|
  puts ("User #{index + 1} creation started")
  admin = User.find_by(email: admin_user[:email], role_id: admin_user[:role_id])
  if admin.present?
    puts ("Admin user #{index + 1} already present with email #{admin_user[:email]}")
  else
    admin_user = User.new(first_name: admin_user[:first_name], last_name: admin_user[:last_name], email: admin_user[:email], role_id: admin_user[:role_id], password: admin_user[:password], password_confirmation: admin_user[:password_confirmation])
    admin_user.save(validate: false)
    admin_user.present? ? puts("Admin user #{index + 1} creation success") : puts("Admin user #{index + 1} creation failed")
  end
end
puts ("User creation completed")
puts("------------------------------------")