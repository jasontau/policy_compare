# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

CUSTOMERS_TO_CREATE = 100
CONSTRUCTION_ACCOUNTS_TO_CREATE = 200
OTHER_ACCOUNTS_TO_CREATE = 250
QUOTES_TO_CREATE_PER_ACCOUNT = 3

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

def generate_coverages(base_property_limit)
  coverage_template = {
    "Building" => {deductible: [1000,2500], limit: [base_property_limit], },
    "Stock" => { limit: [base_property_limit/2] },
    "Privacy Breach Expense" => {limit: [nil, nil, 10000, 25000]},
    "Transit" => {limit: [10000, 5000, 10000]},
    "Comprehensive Extra" => {limit: [nil, 50000, 100000]},
    "Extended Business Income" => {limit: [50000, 100000, 250000]},
    "Employee Dishonesty Form A" => {limit: [2500, 5000, 10000]},
    "Consequential Damage" => {limit: [nil, nil, 5000, 10000, 25000]},
    "Extra Expense" => {limit: [25000, 50000]},
    "Earthquake Shock Endorsement" => {deductible: [25000, 50000, 100000, nil], deductible_percent: [3,5,10,15,20]},
    "Sewer Back-up Coverage Endorsement" => {deductible: [2500, 5000]},
    "Flood Endorsement" => {deductible: [10000, 25000, 50000]},
    "CGL Each Occurrence Limit" => {limit: [1000000, 2000000, 5000000]},
    "General Aggregate Limit" => {limit: [nil, 5000000]},
    "Products - Complete Operations Aggregate" => {limit: [nil, 1000000]},
    "Non-Owned Automobile SPF #6" => {limit: [50000, 75000, 90000]},
    "Tool Floater" => {limit: [nil, 5000, 10000, 25000]}
  }

  result = []
  coverage_template.each do |coverage, params|
    c = Coverage.new
    c.deductible = params[:deductible].sample if params[:deductible]
    c.deductible_percent = params[:deductible_percent].sample if params[:deductible_percent]
    c.limit = params[:limit].sample if params[:limit]
    c.wording = Wording.find_by_name(coverage)
    result << c
  end
  result
end

def generate_quotes(base_property_limit)
  result = []
  rand(QUOTES_TO_CREATE_PER_ACCOUNT+1).times do |i|
    q = Quote.new
    insurer = ""
    policy_num = ""
    case rand(3)+1
    when 1 # Fintact
      insurer = 1
      policy_num = "Q7844#{rand.to_s[2..6]}-#{rand(9)+1}"
    when 2 # Assurance
      insurer = 2
      policy_num = "ASB300#{rand.to_s[2..8]}"
    when 3
      insurer = 3
      policy_num = "QXC974#{rand.to_s[2..6]}-0#{rand(9)+1}"
    end
    q.insurer = Insurer.find(insurer)
    q.policy = policy_num
    q.premium = 1000 + (base_property_limit * 0.35 / 100) * (1 + rand(30))
    q.coverages = generate_coverages(base_property_limit)
    result << q
  end
  result
end

CONSTRUCTION_ACCOUNTS_TO_CREATE.times do |i|
  if Account.count < (CONSTRUCTION_ACCOUNTS_TO_CREATE + OTHER_ACCOUNTS_TO_CREATE)
    sic = Sic.where("segment = ?","Construction").order("RANDOM()").first

    a = Account.new customer: Customer.order("RANDOM()").first,
                    sic: sic,
                    status: Status.order("RANDOM()").first,
                    description: sic.name,
                    user: User.order("RANDOM()").first,
                    effective_date: Time.now().end_of_day + rand(60).days - 30.days
    a.quotes = generate_quotes((rand(30))*5000)
    a.save
  end
end

OTHER_ACCOUNTS_TO_CREATE.times do |i|
  if Account.count < (CONSTRUCTION_ACCOUNTS_TO_CREATE + OTHER_ACCOUNTS_TO_CREATE)
    sic = Sic.where("segment != ?","Construction").order("RANDOM()").first

    a = Account.new customer: Customer.order("RANDOM()").first,
                    sic: sic,
                    status: Status.order("RANDOM()").first,
                    description: sic.name,
                    user: User.order("RANDOM()").first,
                    effective_date: Time.now().end_of_day + rand(60).days - 30.days
    a.quotes = generate_quotes((rand(30))*5000)
    a.save
  end
end
