# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

CSV.foreach("app/assets/csv/sic.csv", headers: true) do |row|
  Sic.create code: row["code"], name: row["name"], segment: row["segment"]
end

CSV.foreach("app/assets/csv/insurer.csv", headers: true) do |row|
  Sic.create name: row["name"], am_best_rating: row["am_best_rating"]
end
