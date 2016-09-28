# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

CUSTOMERS_TO_CREATE = 100

CSV.foreach("app/assets/csv/sic.csv", headers: true) do |row|
  Sic.create code: row["code"], name: row["name"], segment: row["segment"]
end

CSV.foreach("app/assets/csv/insurer.csv", headers: true) do |row|
  Insurer.create name: row["name"], am_best_rating: row["rating"]
end

CSV.foreach("app/assets/csv/sections.csv", headers: true) do |row|
  Section.create name: row["name"]
end

CSV.foreach("app/assets/csv/section_aliases.csv", headers: true) do |row|
  SectionAlias.create name: row["name"],
    section: Section.find_by!(name: row["section"]),
    insurer: Insurer.find_by!(name: row["insurer"])
end

CSV.foreach("app/assets/csv/wordings_fintact.csv", headers: true) do |row|
  puts "#{row["form"]} | #{row["name"]} | #{row["insurer"]} | #{row["section"]} | #{row["equivalent_wording_id"]}"
  Wording.create form: row["form"],
    name: row["name"],
    verbiage: row["verbiage"],
    insurer: Insurer.find_by!(name: row["insurer"])
end

CUSTOMERS_TO_CREATE.times do
  if Customer.count < CUSTOMERS_TO_CREATE
    customer_name = ""
    case rand(1)
    when 0
      customer_name = "#{Faker::Name.name} o/a #{Faker::Company.name}"
    when 1
      customer_name = "#{Faker::Company.name} #{Faker::Company.suffix}"
    end
    Customer.create name: customer_name,
                    address: "#{Faker::Address.street_name}, #{Faker::Address.city}, #{Faker::Address.postcode}",
                    phone: Faker::PhoneNumber.phone_number
  end
end
