class Coverage < ApplicationRecord
  belongs_to :quote
  belongs_to :wording

  validates :wording_id, uniqueness: {scope: :quote_id}

  # Methods
  delegate :name, :form, to: :wording, prefix: true
  def get_alias
    wording.wording_alias.name
  end

  def get_info
    [wording_form, get_alias, deductible, deductible_percent, limit]
  end

  def get_deductible
    r = ""
    r += deductible.to_s if deductible
    r += ("/" + deductible_percent.to_s + "%") if deductible_percent

    r
  end

  def alias_is(wording_alias)
    get_alias == wording_alias
  end
end
