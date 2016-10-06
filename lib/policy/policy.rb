module Policy
  require 'csv'

  def parse(quote)
    info = get_insurer(quote) # TODO: make separate methods
    result = {
      policy: info[:get_policy_number],
      insurer: Insurer.find_by_name(info[:get_insurer]).id,
      coverages: get_wordings(quote, info[:get_insurer])
    }
  end

  private

  def get_insurer(quote)
    #TODO: move to database, find different identifier?
    insurerPolicies = {
      /Q7844\S*/ => "Fintact Insurance",
      /QXC97\S*/ => "Peasant Moon Insurance"
    }

    CSV.foreach("public/#{quote.csv}", headers: false) do |row|
      row.each do |value|
        insurerPolicies.each do |code, insurer|
          if value.present? && value.scan(code).first
            return {get_policy_number: value.scan(code).first, get_insurer: insurer }
          end
        end
      end
    end
  end

  def get_wordings(quote, insurer)
    # TODO: don't brute force it
    wordings = []
    result = []
    Wording.where("insurer_id = ?", Insurer.find_by_name(insurer).id).each do |record|
      # wordings << record.name
      catch :found_wording do
        CSV.foreach("public/#{quote.csv}", headers: false) do |row|
          row.each do |value|
            if value.present? && value.include?(record.name)
              coverage = parse_row(row, insurer)
              coverage[:quote_id] = quote.id
              coverage[:wording_id] = record.id
              result << coverage
              throw :found_wording
            end
          end
        # result << [wording, row]
        end
      end
    end
    result
  end
end

# gets deductible and limit info
def parse_row(row, insurer)
  # TODO: move to database
  insurer_templates = {
    "Fintact Insurance"       => { deductible:2, limit:3, ded_delimiter: '/'},
    "Peasant Moon Insurance"  => { deductible:3, limit:4, ded_delimiter: 'minimum'},
  }

  result = {}
  i = insurer_templates[insurer]

  if row[i[:limit]].present?
    limit = row[i[:limit]].gsub( /\$|\,|\%/, '').to_i
    result[:limit] = limit if limit > 0
  end

  ded = row[i[:deductible]].split(i[:ded_delimiter]).map {|d| d.gsub( /\$|\,|\%/, '').to_i} if row[i[:deductible]]
  #TODO: remove hack - small numbers are always % deductibles
  ded.each do |v| v > 99 ? result[:deductible] = v : result[:deductible_percent] = v end if ded

  result
end
