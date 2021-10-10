# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

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

default_format = [
  {
    name: "Image",
    code: "IMG",
    bundles: [
      {
        quantity: 5,
        price: 450
      },
      {
        quantity: 10,
        price: 800
      }
    ]
  },
  {
    name: "Audio",
    code: "Flac",
    bundles: [
      {
        quantity: 3,
        price: 427.50
      },
      {
        quantity: 6,
        price: 810
      },
      {
        quantity: 9,
        price: 1147.50
      }
    ]
  },
  {
    name: "Video",
    code: "VID",
    bundles: [
      {
        quantity: 3,
        price: 570
      },
      {
        quantity: 4,
        price: 900
      },
      {
        quantity: 9,
        price: 1530
      }
    ]
  }
]
default_format.each do |f|
  format = Format.where(code: f[:code]).first_or_create
  format.update_attribute(:name, f[:name])
  f[:bundles].each do |b|
    bundle = format.format_bundles.where(quantity: b[:quantity]).first_or_create
    bundle.update_attribute(:price, b[:price])
  end

  quantities = f[:bundles].collect{|x| x[:quantity]}
  format.format_bundles.where.not(quantity: quantities).destroy_all
end
puts "Formats & Bundles are now restored!"
