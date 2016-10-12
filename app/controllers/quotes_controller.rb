class QuotesController < ApplicationController
  before_action :find_account, only: [:new, :create]

  include Policy

  def new
    @quote = Quote.new
  end

  def show
    @quote = Quote.find params[:id]
  end

  # upload the pdf/csv raw data
  def create
    @quote = Quote.new(quote_params)
    @quote.account = @account

    extracted_data = parse @quote
    @quote.policy = extracted_data[:policy]
    @quote.insurer_id = extracted_data[:insurer]
    @quote.premium = extracted_data[:premium]

    coverage_array = []
    extracted_data[:coverages].each do |x|
      coverage_array << Coverage.new(x)
    end

    @quote.coverages = coverage_array

    if @quote.save
      redirect_to @account, notice: 'Quote was successfully created.'
    else
      render :new
    end
  end

  # extract and interpret useful info into coverages
  def edit

  end

  private
  def find_account
    @account = Account.find params[:account_id]
  end

  def quote_params
    params.require(:quote).permit(:pdf, :csv, :insurer_id)
  end
end
