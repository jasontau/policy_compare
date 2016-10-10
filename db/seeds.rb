# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

CUSTOMERS_TO_CREATE = 100
ACCOUNTS_TO_CREATE = 300

# Populate Insurer/Wording Data
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

CSV.foreach("app/assets/csv/wording_alias.csv", headers: true) do |row|
  p "#{row["name"]} | #{row["section"]}"
  WordingAlias.create name: row["name"],
    section: Section.find_by!(name: row["section"]),
    description: row["description"],
    irmi: row["irmi"]
end

CSV.foreach("app/assets/csv/wordings_fintact.csv", headers: true) do |row|
  Wording.create form: row["form"],
    name: row["name"],
    verbiage: row["verbiage"],
    insurer: Insurer.find_by!(name: row["insurer"]),
    wording_alias: WordingAlias.find_by!(name: row["wording_alias"] || "null")
end

CSV.foreach("app/assets/csv/wordings_peasant_moon.csv", headers: true) do |row|
  Wording.create form: row["form"],
    name: row["name"],
    verbiage: row["verbiage"],
    insurer: Insurer.find_by!(name: row["insurer"]),
    wording_alias: WordingAlias.find_by!(name: row["wording_alias"] || "null")
end

["New", "Open", "Bound", "Closed"].each do |status|
  Status.create name: status
end

# Create test data
CUSTOMERS_TO_CREATE.times do |i|
  if Customer.count < CUSTOMERS_TO_CREATE
    customer_name = ""
    case rand(2)
    when 0
      customer_name = "#{Faker::Name.name} o/a #{Faker::Company.name}"
    when 1
      customer_name = "#{Faker::Company.name} #{Faker::Company.suffix}"
    end
    Customer.create name: customer_name + i,
                    address: "#{Faker::Address.street_name}, #{Faker::Address.city}, #{Faker::Address.postcode}",
                    phone: Faker::PhoneNumber.phone_number
  end
end

ACCOUNTS_TO_CREATE.times do |i|
  if Account.count < ACCOUNTS_TO_CREATE
    sic = Sic.order("RANDOM()").first
    Account.create  customer: Customer.order("RANDOM()").first,
                    sic: sic,
                    status: Status.order("RANDOM()").first,
                    description: sic.name,
                    user: User.order("RANDOM()").first,
                    effective_date: Time.now().end_of_day + rand(365).days + 10.days
  end
end
