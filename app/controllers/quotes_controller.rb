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

  def download_zip
    send_data "app/assets/policies/raw/PeasantMoonQuote.pdf.zip",
      :filename => "PeasantMoonQuote.pdf.zip",
      :type => "application/zip"

  end

  # upload the pdf/csv raw data
  def create
    # render json: @quote
    @quote = Quote.new params.require(:quote).permit(:pdf)

    # p "************** // "+quote_params[:pdf].path()
    # Send and retrieve file from PDFTables API
    response = HTTMultiParty.post("https://pdftables.com/api?key=#{ENV["PDF_TABLES_KEY"]}&format=csv",
      :query => { f: File.new(quote_params[:pdf].path(), "r") })
    # response = File.read('app/assets/policies/raw/pm_pdftables.csv')

    file = Tempfile.new(['temp','.csv'])
    File.open(file.path, 'w') do |f|
      f.puts response
    end
    file.rewind

    @quote = Quote.new(quote_params)
    @quote.csv = file

    @quote.account = @account

    p "*******************" + quote_params.to_s

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
      file.close
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
