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

    @test = parse @quote
    @quote.policy = @test[:policy]
    @quote.insurer_id = @test[:insurer]

    coverage_array = []
    @test[:coverages].each do |x|
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
