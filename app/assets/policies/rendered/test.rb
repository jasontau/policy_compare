require 'csv'

def get_insurer(name)
  array = []
  ar = SectionAlias.where("insurer_id = ?", id.to_s)
  ar.each do |x| array << x.name end
  array
end

def parse_policy(csv, insurer)
  CSV.foreach(csv, headers: false) do |row|
    row.each do |cont|
      if cont && get_insurer(insurer).any? { |section| section == cont  }
        p cont
      end
    end
  end
end

parse_policy("app/assets/policies/rendered/test_dec.csv", 1)
