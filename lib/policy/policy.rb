module Policy
  require 'csv'

  def parse(quote)
    info = get_insurer(quote) # TODO: make separate methods
    result = {
      policy: info[:get_policy_number],
      insurer: info[:get_insurer],
      wordings: get_wordings(quote, info[:get_insurer])
    }
    # get_insurer(quote).each do |x, v|
    #   result[x] = v
    # end
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
      wordings << record.name
    end
    wordings.each do |wording|
      catch :found_wording do
        CSV.foreach("public/#{quote.csv}", headers: false) do |row|
          row.each do |value|
            if value.present? && value.include?(wording)
              result << row
              throw :found_wording
            end
          end
        # result << [wording, row]
        end
      end
    end
    result


    # result = []
    # CSV.foreach("public/#{quote.csv}", headers: false) do |row|
    #   row.each do |value|
    #   end
    #   result << row
    # end
    # result
  end
end
