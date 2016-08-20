require 'csv'

CSV.foreach("app/assets/policies/rendered/test_dec.csv", headers: false) do |row|
  row.each do |cont|
    if cont.to_s["A. Building and/or Contents"] || cont.to_s["B. Business Interruption Extensions"]
      p cont
    end
  end
  # Sic.create code: row["code"], name: row["name"], segment: row["segment"]
end
