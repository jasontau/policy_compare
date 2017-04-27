class QuotesController < ApplicationController
  before_action :find_account, only: [:new, :create]

  require 'csv'
  require 'json'
  require 'zip'

  include Policy # lib/policy/policy.rb

  def new
    @quote = Quote.new
  end

  def show
    @quote = Quote.find params[:id]
  end

  # upload the pdf/csv raw data
  def create
    # render json: @quote
    @quote = Quote.new params.require(:quote).permit(:pdf)
    @quote = Quote.new(quote_params)

    csv = convert_to_csv(quote_params[:pdf])
    @quote.csv = csv
    @quote.account = @account

    extracted_data = parse @quote
    @quote.policy = extracted_data[:policy]
    @quote.insurer_id = extracted_data[:insurer]
    @quote.premium = extracted_data[:premium]

    coverage_array = []
    extracted_data[:coverages].each do |cover|
      coverage_array << Coverage.new(cover)
    end

    @quote.coverages = coverage_array

    if @quote.save
      csv.close
      redirect_to @account, notice: 'Quote was successfully created.'
    else
      render :new
    end
  end

  def edit

  end

  private
  def find_account
    @account = Account.find params[:account_id]
  end

  def quote_params
    params.require(:quote).permit(:pdf, :csv, :insurer_id)
  end

  def unzip
    Zip::File.open("app/assets/policies/rendered/PeasantMoonQuote.csv.zip") do |zip_file|
      # Handle entries one by one
      zip_file.each do |entry|
        # Extract to file/directory/symlink
        puts "Extracting #{entry.name}"
        entry = zip_file.glob('*.csv').first
        q = parse entry
        p q

      end
    end
  end

  def unzip2

  end
end
