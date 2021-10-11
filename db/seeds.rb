# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Generate default admin account
admin_account = User.where(email: "admin@email.com").first_or_initialize
if admin_account.new_record?
  admin_account.password = "kcknmb"
  admin_account.password_confirmation = "kcknmb"
  admin_account.role = User.roles[:admin]
  admin_account.save
  puts "Admin account created!"
else
  puts "Admin account already exists!"
end

# Generate default format & bundles
Format.load_default
puts "Formats & Bundles are now restored!"
